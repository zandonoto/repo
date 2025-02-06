# x = int(input("What x to find the cube root of? "))
# g = int(input("What guess to start with? "))
# 
# print("Current estimate cubed = ", g**3)
# next_g = g - ((g**3 - x) / (3 * g**2))
# print("next guess to try = ", next_g)

# pset_time = 15
# sleep_time = 8 
# print(sleep_time > pset_time)
# 
# secret = 5


# pset_time = 12
# sleep_time = 12
# if (pset_time + sleep_time) > 24:
#     print("impossible!")
# elif (pset_time + sleep_time) >= 24:
#     print("full schedule!")
# else:
#     leftover = abs(24-pset_time-sleep_time)
#     print(leftover,"h of free time!")
#     print("end of day")

# secret = 5
# user_guess = int(input("Guess a number: "))
# if user_guess == secret:
#     print("You've guessed it - congratulations! It's number 5.")
# elif user_guess < secret:
#     print("Guess higher!")
# else:
#     print("Guess lower!")
# 
# print("thanks!")

# Lecture 3 
# tracker = 0
# where = input("You are in the lost forest. Go left or right? ")
# while where == "right":
#     tracker =  tracker + 1
#     if tracker > 2:
#         print("You are in the lost forest. Go left or right? :( ")
#     
#     where = input("You are in the lost forest. Go left or right? ")
#     
# print("You got out of the lost forest!")

# n = int(input("Enter a non-negative number: "))
# while n > 0:
#     print('x')
#     n = n - 1 # Condition to break the loop

# x = 4
# i = 1
# factorial = 1
# while i <= x:
#     factorial *=  i
#     i = i + 1
# print(f'The factorial of {x} is {factorial}')

# for i in range(1, 4, 1):
#     print(i)
# 
# for j in range(1, 4, 2):
#     print(j*2)
# 
# for me in range(4, 0, -1):
#     print("$"*me)

# mysum = 0
# start = 3
# end = 5
# for i in range(start, end+1):
#     mysum += i
# print(mysum)

# whybitorgay = "?"
# while whybitorgay == whybitorgay:
#     where = input(whybitorgay)
#     whybitorgay += '?'
#     print(whybitorgay)
    