#!/bin/bash

#Initialising balfile as the Current Balance file
balfile="/home/$USER/Current_Balance.txt"
#Initialising transfile as Transaction History file
transfile="/home/$USER/Transaction_History.txt"

if [ $# == 0 ]
then
	echo -e \
	"Invalid usage \n" \
	"specify option -[d]eposit -[w]ithdrawal\n" \
	"specify parameter amount \n" \
	"Ex: $0 -d 500"
elif [ $# == 1 ]
then
	if [ $1 != "-w" ] || [ $1 != "-d" ]
	then
		echo "Please enter valid option -[d]eposit -[w]ithdrawal"
		echo "Example: $0 -d 500"
	else
		echo "Please enter the amount"
		echo "Example: $0 -d 500"
	fi
elif [ $# == 2 ]
then
	bal=$(cat $balfile)
	if [ $1 == "-d" ]
	then
		amt=$2
		echo "$USER +$amt $(date '+%F %T')" >> $transfile
		echo "Transaction Successful [Deposit]"
		newbal=$(bc <<< $bal+$amt)
		echo $newbal > $balfile
		echo "Balance updated"
	elif [ $1 == "-w" ]
	then
		amt=$2
		if [ $(bc <<< "$bal > $amt") -eq 1 ]
		then
			echo "$USER -$amt $(date '+%F %T')" >> $transfile
			echo "Transaction Successful [Withdrawal]"
			newbal=$(bc <<< $bal-$amt)
			echo $newbal > $balfile
			echo "Balance updated"
		else
			echo "Insufficient Balance"
		fi
	else
		echo -e \
		"Invalid usage \n" \
		"specify option -[d]eposit -[w]ithdrawal\n" \
		"specify parameter amount \n" \
		"Ex: $0 -d 500"
	fi
fi
echo "Current Balance: $(cat $balfile)"
