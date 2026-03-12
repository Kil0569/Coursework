'''
Dominic Bumpus
Week 5 Homework
2/5/24
'''

#Problem 1A
print("Problem 1A")

for i in range(10,100,10):
    print(i, end = " ")
print()
print(" ")

#Problem 1B
print("Problem 1B")
for k in range(25,10,-4):
    print(k, end = " ")
print()
print(" ")

#Problem 2
r = range(10,100,10)
#Mark each comment as TRUE or FALSE: 
#True........ This does not cause an error; you can assign a range as the    value of a variable. 
#True........ UNLIKE a list, if you print r, you do NOT see a number. 
#False........ UNLIKE a list, if you print r[2], you do NOT see a number. 
#False........ UNLIKE a list, if you assign n = r[-1], you do NOT get a    number.

#Problem 3
print("Problem 3")
for q in range(1,9,2):
    print(q)
print("End of Problem 3")
print(" ")

#Problem 4
print("Problem 4")
for o in range(0,8):
    print(f"The cube of {o} is {o ** 3}")
print()
print(" ")

#Problem 5
print("Problem 5")
for d in range(20,4,-3):
    if (d%2 == 0):
        print(f"The number {d} is even")
    else:
        print(f"The number {d} is odd")
print()
print(" ")

#Problem 6
print("Problem 6")
print("TEN TIMES PRIMES")
for t in [2,3,5,7,11,13,17,19]:
    print (t*10)
print()

#Have a good day!
