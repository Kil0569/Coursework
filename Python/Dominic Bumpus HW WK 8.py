'''
Dominic Bumpus
Function Homework
02/28/24
'''
#Problem 1
def average(x,y,z):
    result = (x+y+z)/3
    return result

print(average(5,4,7))


#Problem 2

def count_down(n=10):
    for a in range(n,0,-1):
        print()
        for s in range (a):
            print(f"{a:4}", end="")
    return "\n AND THAT IS ALL"
print(count_down())


#Problem 3
def count_of_targets(source_string, target):
    if (len(target)==1):
        count = 0
        for a in source_string:
            if a == target:
                count = count + 1
        return count
    else:
        return None
    
print(count_of_targets("This is the test string for the function", "t"))