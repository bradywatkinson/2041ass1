#!/usr/bin/python
import sys
sys.stdout.write("Enter a number: ")
a = int(sys.stdin.readline())
sys.stdout.write("Enter another number: ")
b = int(sys.stdin.readline())
if a % b == 0:
    print "%s divides %s" % (b, a)
else:
    print "%s does not divide %s" % (b, a)
