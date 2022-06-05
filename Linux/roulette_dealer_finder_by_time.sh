#!/bin/bash

#change the script to ask for input rather than getting it from the execution line

#Variables

#Variable 1 is the date which is a four figure mmdd
#Variable 2 is the hour  which should be two digits like on the hour hand of a clock so 01 or 10 and so on
#Variable 3 is the  am/pm designation so am or pm


	echo "Dealer schedule audit file exists for $date"
        echo "*******************************************"
	grep -i ${2}:00:00' '$3 ${1}_Dealer_schedule

