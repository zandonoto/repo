SET NOCOUNT ON

DROP TABLE IF EXISTS #List
DROP TABLE IF EXISTS #Temp

-- Lista de contratos ativos de Nibo Emissor de Notas Fiscal
WITH ContractsList AS (
    SELECT  
          [ReportDate]
        , [ConsumptionStartDate]
        , [ConsumptionEndDate]
        , [ReferenceMonth]                                    
        , [AccountantId]
        , [AccountantName]
        , [FeatureId]
        , [Units]
        , CAST([MinimumUnits] AS DECIMAL(10, 2))                                    AS [MinimumUnits]
        , [Total]
        , ROW_NUMBER() OVER(PARTITION BY [AccountantId] ORDER BY [ReportDate] DESC) AS [RowNumberDESC]
        , ROW_NUMBER() OVER(PARTITION BY [AccountantId] ORDER BY [ReportDate] ASC)  AS [RowNumberASC] 

        FROM [Accountants].[ActiveSubscriptionsFeatures]

        WHERE 1=1
            AND [FeatureId] = 'NFSeIssuerCustomer'
            AND (
                [ClosedMonth] = 1
                OR ([ReportDate] >= DATEADD(DAY, 1, EOMONTH(GETDATE()-30)))
            ),

-- Data de contratação do cliente
FirstContractDate AS (
    SELECT       
          [FirstDate].[ReportDate] [FirstReportDate]
        , [FirstDate].[AccountantId] [FirstAccountantId]
        , [FirstDate].[ReferenceMonth] [FirstReferenceMonth]

        FROM ContractsList [FirstDate]

        WHERE 1=1
            AND [FirstDate].[RowNumberASC] = 1

)

-- Data de última atividade do cliente
, LastContractDate AS (
    SELECT 
          [LastDate].[ReportDate] [LastReportDate]
        , [LastDate].[AccountantId] 
        , [LastDate].[ReferenceMonth] AS [LastReferenceMonth]

        FROM ContractsList [LastDate]

        WHERE 1=1
            AND [LastDate].[RowNumberDESC] = 1
    
)  

SELECT
      [HUB].[ReferenceId]
    , [C].[ReportDate]
    , CONVERT(date, CONCAT([MIN].[FirstReferenceMonth], '-01')) AS [FirstReferenceMonth]
    , [C].[ReferenceMonth]
    , [MIN].[FirstReportDate]
    , [LastReferenceMonth]
    , [Last].[LastReportDate]
    , CONVERT(DATE, FORMAT([HUB].[CreateDate], 'yyyy-MM-01'))                                AS [CreateDate]
    , SUM([NFSeCompaniesEnabledCount]) / SUM([MinimumUnits])                                 AS [Activation%]
    , SUM (
        CASE 
        WHEN ([NFSeCompaniesEnabledCount]) / ([MinimumUnits]) > 0.5 THEN 1
        ELSE 0 
        END)                                                                                  AS [Activation]
        
    INTO #List
    FROM Hubspot.Deals [HUB]

    LEFT JOIN [Hubspot].[ProductMap] [PMAP]
        ON [HUB].[Product] = [PMAP].[ProductName]

    LEFT JOIN [ContractsList] [C]
        ON [HUB].[ReferenceId] = [C].[AccountantId]
        AND [PMAP].[FeatureId] = [C].[FeatureId]

    LEFT JOIN [Accountants].[Indicators] [ACI]
        ON [C].[AccountantId] = [ACI].[AccountantId]
        AND [C].[ReportDate] = [ACI].[ReportDate] 

    LEFT JOIN FirstContractDate [MIN]
        ON [HUB].[ReferenceId] = [MIN].[FirstAccountantId]

    LEFT JOIN LastContractDate [Last]
        ON [HUB].[ReferenceId] = [Last].[AccountantId]

    WHERE 1=1
        AND [PMAP].[FeatureId] = 'NFSeIssuerCustomer'
        AND [HUB].[Pipeline] = 'Sucesso'
        AND [C].[ReferenceMonth] IS NOT NULL
        AND [HUB].[Stage] != 'Churn'
    
    GROUP BY 
          [HUB].[ReferenceId]
        , [MIN].[FirstReportDate]
        , [Last].[LastReportDate]
        , [C].[ReportDate]
        , [HUB].[CreateDate]
        , [MIN].[FirstReferenceMonth]
        , [C].[ReferenceMonth]
        , [LastReferenceMonth]


DECLARE @MinDate date = (SELECT MIN(CreateDate) FROM #List)
DECLARE @MaxDate date = DATEADD(MONTH,1,getdate())

INSERT INTO @temp
 SELECT FORMAT([Period].PeriodStartDate, 'yyyy-MM') + ' (' + (SELECT TOP 1 CONVERT(nvarchar, COUNT(DISTINCT [ReferenceId])) FROM #List WHERE FORMAT([#List].CreateDate, 'yyyy-MM') = FORMAT([Period].PeriodStartDate, 'yyyy-MM')) + ')' [YearMonth]
      , Progress
	  , (
        SELECT 
        CAST(SUM([Activation]) AS DECIMAL(10,2)) / CAST(COUNT([Activation]) AS DECIMAL(10,2))
     
        FROM #List [L]
        
        WHERE [CreateDate] = PeriodStartDate 
            AND [ReferenceMonth] BETWEEN FORMAT(ProgressStartDate, 'yyyy-MM') AND FORMAT(ProgressEndDate, 'yyyy-MM')

      )
    
   FROM [dbo].[GetCustomCohortPeriods](@MinDate, @MaxDate, 'm') [Period]


EXEC OutputCohort @temp, 'AVG' 

