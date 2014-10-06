#!/bin/usr/python -w
import sys

# Finding squares
x = 2
print "Squares between 4 and 256"
while x < 101:
    x = x ** 2
    print x


for i in range(2): print i

#print a checker board thing
print
print "Checkers!"
sys.stdout.write("Enter a number plz: ")
s = int(int(int(sys.stdin.readline())))
for x in range(s):
    for y in range(s):
        if (x+y) % 2 == 1: sys.stdout.write("*")
        else: sys.stdout.write("o")
    print


q = "101"
print "Values of q is", int(q)
print "201 looks like", int("201")

sys.stdout.write("\n");
print "Halfing from 100"
x = 100
while 1: 
    print x; x = x >> 1
    if x < 10: break

print
print "Its foobar!"
for x in range(10):
    if x%2==0 and       x    %3==0: print "Foobar is", x
    elif x % 2 == 0: print "Foo is", x
    elif x % 3 == 0: print "Bar is", x
    else:
        print x, "is not foo or bar!"
