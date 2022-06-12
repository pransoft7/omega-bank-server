#!/bin/bash

#NIT T, Delta Club Induction, 202206
#Pranava S Kumar Roll No 103121087
#Civil Engg 2021-2025

while read acc_name status category acc_type
do
	netint=0
	while read -r key value
	do	
		if [ $status != "-" ]
		then
			[[ $key == $status ]] && netint=$(bc <<< $netint+$value)
		fi
		if [ $category != "-" ]
		then
			[[ $key == $category ]] && netint=$(bc <<< $netint+$value)
		fi
		if [ $acc_type != "-" ]
		then
			[[ $key == $acc_type ]] && netint=$(bc <<< $netint+$value)
		fi
	done < /home/$USER/Daily_Interest_Rates.txt
	echo "Net interest for $acc_name : $netint%"
	bal=$(cat /home/$acc_name/Current_Balance.txt)
        intamt=$(bc <<< $netint*$bal)
	newbal=$(bc <<< $bal+$intamt)
        echo "$acc_name +$intamt $(date '+%F %T')" >> /home/$acc_name/Transaction_History.txt
	echo $newbal > /home/$acc_name/Current_Balance.txt
	echo "Interest alloted for the Account"
done < /home/$USER/accountList.txt
