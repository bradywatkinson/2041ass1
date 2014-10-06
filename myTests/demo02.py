#!/usr/bin/python

import sys
lines = []
a = "test"
lines.append(a+"_append\n")
lines.append(a+"_append\n")

i = len(lines) - 1
while i >= 0:
    print lines[i],
    i = i - 1
