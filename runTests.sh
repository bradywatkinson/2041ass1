#!/bin/sh

test=`./python2perl.pl examples/1/answer0.py | perl`
if [ $test = 42 ]; then
	echo 'Passes answer0.py'
else
	echo 'Fails answer0.py'
fi

test=`./python2perl.pl examples/1/answer1.py | perl`
if [ $test = 42 ]; then
	echo 'Passes answer1.py'
else
	echo 'Fails answer1.py'
fi

test=`./python2perl.pl examples/1/answer2.py | perl`
if [ $test = 42 ]; then
	echo 'Passes answer2.py'
else
	echo 'Fails answer2.py'
fi

test=`./python2perl.pl examples/1/answer3.py | perl`
if [ $test = 42 ]; then
	echo 'Passes answer3.py'
else
	echo 'Fails answer3.py'
fi

test=`./python2perl.pl examples/1/answer4.py | perl`
if [ $test = 42 ]; then
	echo 'Passes answer4.py'
else
	echo 'Fails answer4.py'
fi

test=`./python2perl.pl examples/2/answer5.py | perl`
if [ $test = 42 ]; then
	echo 'Passes answer5.py'
else
	echo 'Fails answer5.py'
fi

test=`./python2perl.pl examples/2/answer6.py | perl`
if [ $test = 42 ]; then
	echo 'Passes answer6.py'
else
	echo 'Fails answer6.py'
fi

./python2perl.pl examples/2/iota.py | perl > test1
cat examples/2/iota.py | python > test2
diff test1 test2
if test "$?" -ne 0; then
	echo "Test Failed!"
else 
	echo "Passes iota.py"
fi

./python2perl.pl examples/3/five.py | perl > test1
cat examples/3/five.py | python > test2
diff test1 test2
if test "$?" -ne 0; then
	echo "Test Failed!"
else 
	echo "Passes five.py"
fi

test=`./python2perl.pl examples/3/prime0.py | perl`
if [ $test = 25 ]; then
	echo 'Passes prime0.py	'
fi

test=`./python2perl.pl examples/3/prime1.py | perl`
if [ $test = 25 ]; then
	echo 'Passes prime1.py	'
fi

./python2perl.pl examples/3/tetrahedral.py | perl > test1
cat examples/3/tetrahedral.py | python > test2
diff test1 test2
if test "$?" -ne 0; then
	echo "Test Failed!"
else 
	echo "Passes tetrahedral.py"
fi

./python2perl.pl examples/3/triangle.py | perl > test1
cat examples/3/triangle.py | python > test2
diff test1 test2
if test "$?" -ne 0; then
	echo "Test Failed!"
else 
	echo "Passes triangle.py"
fi

./python2perl.pl examples/4/line_count.1.py > test_script.pl
./test_script.pl <python2perl.pl >test1
python examples/4/line_count.1.py <python2perl.pl >test2
diff test1 test2
if test "$?" -ne 0; then
	echo "Test Failed!"
else 
	echo "Passes line_count.1.py"
fi



