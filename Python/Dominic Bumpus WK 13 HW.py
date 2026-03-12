'''
Dominic Bumpus
04/12/24
WK 13 Post Exam HW
'''

#Problem 1
def mirror_writing(sourceFile, destinationFile):
    with open(sourceFile, 'r') as source:
        with open(destinationFile, 'w') as destination:
            for line in source:
                reversed_line = line.rstrip()[::-1] + "\n"
                destination.write(reversed_line)

mirror_writing("source.txt", "destination.txt")

#Problem 2
source_list = ["2", "123abc", "456dEF", "George", "puppy"] 
z = [y for y in source_list if y == y.lower()]
print(z)

#Problem 3
def expander(string_list):
    for a in string_list:
        a+="\n"
        for k in a:
            k+=" "
            print(k, end="")

expander(["abc", "1234", "Password123"])

#Problem 4
def flip_values_and_keys(src):
    dst = {}
    for k in src:
        v = src[k]
        dst[v] = k
    return dst

src = {1:111, 2:22, 3:"Three", "V":5} 
dst = flip_values_and_keys(src)
print(dst)
