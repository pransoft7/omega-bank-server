#!/bin/bash

branchBal=0

> /home/$USER/Branch_Transaction_History.txt

while read acc_name status category legacy
do
	accBal=$(cat /home/$acc_name/Current_Balance.txt)
	branchBal=$(bc <<< $branchBal+$accBal)
	cat /home/$acc_name/Transaction_History.txt >> /home/$USER/Branch_Transaction_History.txt
done < /home/$USER/accountList.txt

echo $branchBal > /home/$USER/Branch_Current_Balance.txt
