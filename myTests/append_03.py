#!/usr/bin/python

import sys

lines = []
a = "_extra"
for line in sys.stdin:
    lines.append("test_append"+a)
    
i = len(lines) - 1
while i >= 0:
    print lines[i],
    i = i - 1
