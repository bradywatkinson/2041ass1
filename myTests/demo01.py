#!/usr/bin/python

import sys
lines = []

lines.append("test_append\n")
lines.append("test_append\n")

i = len(lines) - 1
while i >= 0:
    print lines[i],
    i = i - 1
