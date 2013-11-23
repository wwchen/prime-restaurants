#!/bin/bash

file=`mktemp XXXXX`

ruby crawl_microsoftprime.rb $file.html
ruby parse_primelist.rb $file.html $file.json
ruby parse_primelist.rb $file.html $file.txt
mv $file.json all.json
mv $file.txt all.txt
rm $file $file.*
