#!/usr/bin/python

import sys

#print a checker board thing
print
print "Checkers!"
sys.stdout.write("Enter a number plz: ")
s = int(int(int(sys.stdin.readline())))
for x in range(0, s):
    for y in range(0, s):
        if (x+y) % 2 == 1: sys.stdout.write("*")
        else: sys.stdout.write("o")
    print
