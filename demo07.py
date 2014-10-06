#!/usr/bin/python
import sys

sys.stdout.write("Enter a number: ")
number = int(sys.stdin.readline())
sys.stdout.write("Enter a word: ")
word = sys.stdin.readline()
for i in range(0, number):
	if number % 2 == 0:
		print word
	else:
		print "bad word"
print "Bye"

