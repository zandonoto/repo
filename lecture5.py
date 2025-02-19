# Number to base 2
# Because we have a limited numbers of bits that can be stored in our computer system (32 or 64 bits), we need to represente the numbers in a binary format.
# Thats why we need to use that kind of method to get approximiation of the number we want to represent, so it doesnt fail to represent the number we need to find.
# The following code will convert a number to its binary representation.

# num = -10

# Inicializa a variável result
# result = ''

# if num < 0:
#     is_neg = True
#     num = abs(num)
# else:
#     is_neg = False

# if num == 0:
#     result = '0'

# while num > 0:
#     result = str(num % 2) + result
#     num = num // 2 

# if is_neg:
#     result = '-' + result

# print(result)


# x = float(input('Enter a decimal number between 0 and 1: '))

# p = 0
# while ((2**p)*x)%1 != 0:
#     print(f'Remainder = {str((2**p)*x - int((2**p)*x))}')
#     p += 1

# num = int(x*(2**p))

# result = ''
# if num == 0:
#     result = '0'
# while num > 0:
#     result = str(num%2) + result
#     num = num//2

# for i in range(p - len(result)):
#     result = '0' + result

# result = result[0:-p] + '.' + result[-p:]
# print(f'The binary representation of the decimal {str(x)} is {str(result)}')


################
## EXAMPLE: Approximation by epsilon increments
## Incrementally fixing code as we find issues with approximation
################

# try with 36, 24, 2, 12345
# x = 549383
# epsilon = 0.01
# num_guesses = 0
# guess = 0.0
# increment = 0.0001
# while abs(guess**2 - x) >= epsilon and guess**2 <= x:
#     guess += increment
#     num_guesses += 1
#     if num_guesses%100000 == 0:
#         print(f'Current gues = {guess}')
#         print(f'Current guess**2 - x - = {abs(guess*guess -x)}')
#     if num_guesses%100000 == 0:
#         input('Contunue?')
# print(f'num_guesses = {num_guesses}')

# print(f'{guess} is close to square root of {x}')


# Add an extra stopping condition 
# and check for why the loop terminated
# x = 54321
# epsilon = 0.01
# num_guesses = 0
# guess = 0.0
# increment = 0.00001  # try with 0.00001
# while abs(guess**2 - x) >= epsilon and guess**2 <= x:
#     guess += increment
#     num_guesses += 1
# print(f'num_guesses = {num_guesses}')
# if abs(guess**2 - x) >= epsilon:
#     print(f'Failed on square root of {x}')
#     print(f'Last guess was {guess}')
#     print(f'Last guess squared is {guess*guess}')
# else:
#     print(f'{guess} is close to square root of {x}')
    
# Floating point numbers introduce challenges
# They can't be represented in memory exactly