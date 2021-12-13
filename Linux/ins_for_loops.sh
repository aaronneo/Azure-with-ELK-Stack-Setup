#!/bin/bash

# for <item> in <list>
# do
#   <run_this_command>
#   <run_this_command>
# done


# list variables
months=(
    'january'
    'february'
    'march'
    'april'
    'may'
    'june'
    'july'
    'august'
    'september'
    'october'
    'november'
    'december'
)
days=('mon' 'tues' 'wed' 'thur' 'fri' 'sat' 'sun')

# create for loops

#print out months
for month in ${months[@]}
do 
    echo $month
done
