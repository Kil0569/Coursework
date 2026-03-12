'''
Dominic Bumpus
Alphabetizing Homework
03/26/24
'''
#Function Def
def alphabetize(str_list):
    #Outer Loop
    for done in range(1, len(str_list)):
      #Inner Loop
      for n in range(done, 0, -1):
            if str_list[n] >= str_list[n - 1]:
                break
            else:
                str_list[n], str_list[n - 1] = str_list[n - 1], str_list[n]

#Testing
strings = ["abc", "yz", "ghi","mno", "def", "stu","jkl", "pqr", "vwx"]
alphabetize(strings)
print(strings)

#Have a good day :D