#!/usr/bin/python
import sys
x = 1
while x < 10:
    y = 1
    while y < 10:
        if (x % 3 == 1):
            if (y % 2 == 0):
                sys.stdout.write("*")
        y = y + 1
    print
    x = x + 1
