#!/bin/bash  
# flutter run -d R5CN90JR54W --pid-file /tmp/flutter.pid

while true
do
    find lib/ -name '*.dart' | \
        entr -d -p ./hotreloader.sh /_
done