#!/bin/bash

cat requirements.txt | while read LINE
do
    brew install $LINE
done
