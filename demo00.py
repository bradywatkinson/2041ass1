#!/usr/bin/python

import sys
lines = []
a = "test_append\n"
lines.append(a)
lines.append(a)

i = len(lines) - 1
while i >= 0:
    print lines[i],
    i = i - 1
