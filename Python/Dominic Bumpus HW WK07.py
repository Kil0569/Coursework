'''
Dominic Bumpus
WK07 Homework
02/18/24
'''

#PROBLEM 1

Rows = int(input("Please enter the number of rows you would like: "))
for a in range(Rows+1):
    print()
    count = a
    for s in range(a):
        print(f"{count:4}", end="")
        count = count - 1
    print()
print()

#PROBLEM 2

count2 = 0
NL = [1,2,3,],["a","b","c"],[1,1,1,1,1,"2"]
for a in NL:
    for b in a:
        if (type(b)==str):
            count2 = count2 +1
print(f"There are {count2} strings")