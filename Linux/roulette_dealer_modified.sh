#!/bin/bash

#Variables

#Variable 1 is the date which is a four figure mmdd
#Variable 2 is the hour  which should be two digits like on the hour hand of a clock so 01 or 10 and so on
#Variable 3 is the  am/pm designation so am or pm
#Variable 4 is the game being - none, roulette, blackjack, or texas.


#These really need to be nested so that an error can be spat out but no time.

	if [ $4 = "none" ]
		then
		echo "Dealer schedule audit file exists for $date"
        	echo "*******************************************"
		grep -i ${2}:00:00' '$3 ${1}_Dealer_schedule
	else
		echo "Asking for a specific game dealer"
	fi

	if [ $4 = "roulette" ]
		then
                echo "Dealer schedule audit file exists for $date"
                echo "*******************************************"
                grep -i ${2}:00:00' '$3 ${1}_Dealer_schedule | awk -F" " '{print $1,$2,$5,$6}'
	fi

	if [ $4 = "blackjack" ]
		then
                echo "Dealer schedule audit file exists for $date"
                echo "*******************************************"
                grep -i ${2}:00:00' '$3 ${1}_Dealer_schedule | awk -F" " '{print $1,$2,$3,$4}'
	fi
	
	if [ $4 = "texas" ]
		then
		echo "Dealer schedule audit file exists for $date"
                echo "*******************************************"
                grep -i ${2}:00:00' '$3 ${1}_Dealer_schedule | awk -F" " '{print $1,$2,$7,$8}'
        fi

