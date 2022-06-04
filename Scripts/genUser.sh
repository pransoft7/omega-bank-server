#!/bin/bash

#Contains genUser and permit modules
#To be run by obsysad - generate users from User_Accounts.txt & Branch Managers can add Account holders for their branch manually

function create_acc_holder() {
	sudo useradd -m $acc_name
	echo "User $acc_name created successfully"
	sudo touch /home/$acc_name/Current_Balance.txt /home/$acc_name/Transaction_History.txt
	sudo chown $acc_name:$acc_name /home/$acc_name/Current_Balance.txt /home/$acc_name/Transaction_History.txt
	sudo chmod 660 /home/$acc_name/Current_Balance.txt /home/$acc_name/Transaction_History.txt
	echo $acc_name $status $category $acc_type | sudo tee -a /home/$branch/accountList.txt > /dev/null
	sudo echo "$acc_name +500 $(date '+%F %T')" | sudo tee -a /home/$acc_name/Transaction_History.txt > /dev/null
	echo 500 | sudo tee -a /home/$acc_name/Current_Balance.txt > /dev/null
	echo "Current balance and transaction history created"
	sudo usermod -a -G $acc_name $branch
	sudo usermod -a -G $acc_name ceo
}

if [ ! -z $1 ] && [ -s $1 ]
then
    if [ -z $(grep ceo /etc/passwd) ]
    then    
	sudo useradd -m ceo
	echo CEO account created
    fi
    while read acc_name branch status category acc_type
    do
	br=$(grep $branch /etc/passwd)
	echo acc_name: $acc_name
	echo branch: $branch
	echo citizenship: $status
	echo agegroup : $category
	echo acc_type : $acc_type
	if [[ -z "$br" ]]
	then
		sudo useradd -m $branch
		echo "Branch manager added"
		intRateFile="/home/$branch/Daily_Interest_Rates.txt"
		brBalFile="/home/$branch/Branch_Current_Balance.txt"
		brTransFile="/home/$branch/Branch_Transaction_History.txt"
		accListFile="/home/$branch/accountList.txt"
		sudo touch $brBalFile $brTransFile $accListFile $intRateFile
		sudo chown $branch:$branch $brBalFile $brTransFile $accListFile $intRateFile
		sudo chmod 600 $brBalFile $brTransFile $accListFile $intRateFile
		sudo echo "minor 0.003" | sudo tee -a $intRateFile >> /dev/null
		sudo echo "seniorCitizen 0.005" | sudo tee -a $intRateFile >> /dev/null
		sudo echo "foreigner 0.007" | sudo tee -a $intRateFile >> /dev/null
		sudo echo "resident 0.009" | sudo tee -a $intRateFile >> /dev/null
		sudo echo "citizen 0.010" | sudo tee -a $intRateFile >> /dev/null
		sudo echo "legacy 0.004" | sudo tee -a $intRateFile >> /dev/null
		echo "Default Daily_Interest_Rates created"
		echo "Account_Holders_List, Branch balance and transaction history created"
		sudo usermod -a -G $branch ceo
	else
		echo "Branch already exists"
	fi
	create_acc_holder
    done < "$1"
else
    echo "Welcome Branch Manager! Provide account details to be created"
    echo "Enter Account Name: "
    read acc_name
    echo "Enter Branch:"
	read branch
    echo "Enter Status: "
    read status
    echo "Enter Category: "
    read category
    echo "Enter Account Type: "
    read acc_type
    echo
	create_acc_holder
fi