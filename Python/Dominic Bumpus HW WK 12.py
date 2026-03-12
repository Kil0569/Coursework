'''
Dominic Bumpus
Week 12 HW
04/06/24
'''

#Problem 1
def read_n_numbers_add_them_up(filename, line_count):
    sum = 0.0
    with open(filename, 'r') as file:
        for a in range(line_count):
            line = file.readline().strip()
            sum += float(line)
        return sum
    file.close()

print(read_n_numbers_add_them_up("numbers.txt",7))


#Problem 2a
w = [a for a in range(10,41) if a%5 == 0 and a%3 == 0]
print(w)

#Problem 2b
sss = ["snake", "dog", "hippo","cat"]
p = [k for k in sss if "a" in k]
print(p)

#Problem 3
def find_the_exit(maze):
    for a in maze:
        for k in a:
            if k==0:
                j = maze.index(a)
                return(j,k)
print(find_the_exit([[1,2,3],[4,5,6],[7,8,9],[10,0,1]]))


    