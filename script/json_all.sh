#!/bin/bash

rm -f prime.html
echo "Craling prime website"
ruby ./1_crawl_microsoftprime.rb -r 11 prime.html
echo "Parsing html and converting to json"
ruby ./2_parse_primelist.rb prime.html -t json
echo "Post processing json"
ruby ./3_process_json.rb prime.json -o prime-geocoded.json
