#!/usr/bin/env bash

while true ; do
    ruby script/fetch_new_modules.rb
    sleep 1
    #sleep $((60*10))
done
