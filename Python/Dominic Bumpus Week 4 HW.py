#1. Boolean vs Math: )
    #In Boolean: True, but in math: 3.

################################################################################################
#HOT DOG PROBLEM


#Input Hot Dogs Being Served
hotdogs_served = int( input("How many Hot Dogs do you intend on serving?: "))


#Calculate Bun Packs Required
buns_required = hotdogs_served/8
if ((buns_required % 8) != int):
    buns_required = int(buns_required) + 1
    
    
#Calculate Hot Dog Packs Required
hotdogs_required = hotdogs_served/10
if (hotdogs_required != int):
    hotdogs_required = int(hotdogs_required) +1
    
#Print what the user needs to buy in a readable format
print("\n" "The number of bun packs you need to buy is: ", buns_required)
print("The number of hot dog packs you need to buy is: ", hotdogs_required)

#Making the message "nice" :p
print("Have a wonderful day!" "\n")

################################################################################################
#SCORE TO GRADES


#Input student grade in percentage
student_score = float(input("Please enter the percentage grade of the student: "))


#Input Validation
if (student_score > 100):
    print("Invalid grade, please try again")
    
if (student_score < 0):
    print("Invalid grade, please try again")
    
    
#Very long if-elif-else to determine proper grade based on inputted percentage
elif (student_score <= 100 and student_score >= 90):
    print("Studnet Grade: A")

elif (student_score <= 89 and student_score >= 80):
    print("Studnet Grade: B")

elif (student_score <= 79 and student_score >= 70):
    print("Studnet Grade: C")

elif (student_score <= 69 and student_score >= 60):
    print("Studnet Grade: D")

elif (student_score <= 59 and student_score >= 50):
    print("Studnet Grade: E")

elif (student_score <= 49 and student_score >= 40):
    print("Studnet Grade: F")


#From this point forward it would go to G based on the assignment but F is the usual letter grade that is the lowest
    
    
elif (student_score <= 39 and student_score >= 30):
    print("Studnet Grade: F")

elif (student_score <= 29 and student_score >= 20):
    print("Studnet Grade: F")

elif (student_score <= 19 and student_score >= 10):
    print("Studnet Grade: F")
    
elif (student_score <= 9 and student_score >= 0):
    print("Studnet Grade: F")

################################################################################################
#LIST ACCESS PROBLEM
    
    
#New Line
print("\n")

#Calories List
calories = [350, 500, 1200]

#List Index Addition
calories_total = calories[0] + calories[1] + calories[2]

#Total Calories Statment to User
print("Your total calories for the day adds up to: ", calories_total)


#Hope you're having a good day today Prof. Carroll!

