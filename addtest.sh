#!/bin/sh
if [ -e "t/cases/$1."* ]
then
	echo 'Test already exists' 1>&2
	exit 1
fi
echo "$2" > "t/cases/$1.xml"
echo "$2" | xml2 > "t/cases/$1.txt"
echo "Added test $1"
