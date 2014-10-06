#!/bin/usr/python -w

answer = 41
if answer > 0: answer = answer + 2
if answer == 43: answer = answer - 1
print answer

answer = 0
x = 1
while answer < 36: answer = answer + 7

print answer

x = 1
while x <= 10: print x; x = x + 1

q = a or 1
p = (1 or 0) and (0 and 1)
print p

q = ~1
q = ~q

x = 5
while x < 10 and x > 0 or x < 0: x += 1

x = 10
while 1 == 1: x = x - 1; break
if x == 9: print "yosh"
