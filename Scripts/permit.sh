#!/bin/bash

#NIT T, Delta Club Induction, 202206
#Pranava S Kumar Roll No 103121087
#Civil Engg 2021-2025

# To be run by obsysad - provide User_Accounts.txt as command line argument
# Should be run after running genUser script

function accholder_permit() {
	sudo chown $acc_name:$acc_name /home/$acc_name/Current_Balance.txt /home/$acc_name/Transaction_History.txt
	sudo chmod 660 /home/$acc_name/Current_Balance.txt /home/$acc_name/Transaction_History.txt
	echo Permissions updated for $acc_name files
	sudo usermod -a -G $acc_name $branch
	sudo usermod -a -G $acc_name ceo
	echo Branch Manager and CEO added to $acc_name group
}

function branch_permit() {
	# Initialise the variables before using the function
	sudo chown $branch:$branch $brBalFile $brTransFile $accListFile $intRateFile
	sudo chmod 600 $brBalFile $brTransFile $accListFile $intRateFile
	echo Permissions updated for $branch files
	sudo usermod -a -G $branch ceo
	echo CEO added to $branch group
}

if [ -z $(grep ceo /etc/passwd) ]
then    
	sudo useradd -m ceo
	echo CEO account created
fi


while read branch
do
	intRateFile="/home/$branch/Daily_Interest_Rates.txt"
	brBalFile="/home/$branch/Branch_Current_Balance.txt"
	brTransFile="/home/$branch/Branch_Transaction_History.txt"
	accListFile="/home/$branch/accountList.txt"
	branch_permit
done < /home/$USER/branchList.txt


while read acc_name branch others
do
	accholder_permit
done < /home/$USER/User_Accounts.txt
