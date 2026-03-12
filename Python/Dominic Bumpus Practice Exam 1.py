'''
Dominic Bumpus
Practice Exam #1
02/06/24
'''

#Problem A
x = float(input("Please enter a number for variable x: "))
y = float(input("Please enter a number for variable y: "))

for o in range(int(x),int(y),1):
    print(o)
print()

#Problem B
n = 1
k = 2

if(n%k == 0):
    print("Yes")
else:
    print ("No")


#Problem C
user_string = input("Please enter a string: ")
vowels = ["a", "A", "e","E", "i", "I", "o", "O", "u", "U"]
count = 0
for char in user_string:
    if char in vowels:
        count = count + 1

print(f"The number of vowels in that string is: {count}")

    