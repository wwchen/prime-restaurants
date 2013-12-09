#!/bin/bash

rm -f prime.html
echo "Craling prime website"
ruby ./1_crawl_microsoftprime.rb -r 11 prime.html
echo "Parsing html and converting to json"
ruby ./2_parse_primelist.rb prime.html -t json
echo "Post processing json"
ruby ./3_process_json.rb prime.json -o prime-geocoded.json | tee process.log

cat prime-geocoded.json | python -mjson.tool > ../data/restaurants.js
echo "Log saved to 'process.log' file"
echo "git stash save will be executed next. Press any key to continue"
read
git stash save
git add prime.html prime.json prime-geocoded.json ../data/restaurants.js
echo "== Commit message - copy and paste =="
echo "List of prime restaurants, current as of `date '+%b%e, %Y'`"
echo "===="
echo "git commit will be excuted next. Press any key to continue"
read
git commit
git stash pop
