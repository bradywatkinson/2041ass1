#!/usr/bin/python
# written by andrewt@cse.unsw.edu.au as a COMP2041 lecture example
# Count the number of lines on standard input.

import sys
line = "banana"
lines = []
lines.append("first line")
lines.append("second line\n")
    
i = len(lines) - 1
while i >= 0:
    print lines[i],
    i = i - 1
