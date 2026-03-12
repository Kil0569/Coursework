'''
Dominic Bumpus
04/18/24
Rectangle HW
'''

class Rectangle:
    def __init__(self, x1, y1, x2, y2):
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2

    def area(self):
        width = self.x2 - self.x1
        height = self.y1 - self.y2
        return width * height

    def perimeter(self):
        width = self.x2 - self.x1
        height = self.y1 - self.y2
        return 2 * (width + height)

    def point_within(self, x, y):
        return self.x1 <= x <= self.x2 and self.y2 <= y <= self.y1

rectangle = Rectangle(1, 3, 5, 1)
print("Area:", rectangle.area())
print("Perimeter:", rectangle.perimeter())
print("Is point (3, 2) within the rectangle?", rectangle.point_within(3, 2))
