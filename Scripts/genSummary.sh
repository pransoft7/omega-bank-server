#!/bin/bash

#NIT T, Delta Club Induction, 202206
#Pranava S Kumar Roll No 103121087
#Civil Engg 2021-2025

# Displays accounts with highest change in bank balance

# Initialising "Change in Balance" file as balDiffFile
balDiffFile="/home/$USER/balDiffList.txt"

> $balDiffFile

while read acc_name others
do
	highest=$(cat /home/$acc_name/Transaction_History.txt | grep $(date '+%Y-%m')  | cut -d" " -f5 | sort -V | tail -1)
	lowest=$(cat /home/$acc_name/Transaction_History.txt | grep $(date '+%Y-%m') | cut -d" " -f5 | sort -V | head -1)
	#echo "Lowest balance is $lowest"
	#echo "Highest balance is $highest"
	Diff=$(bc <<< $highest-$lowest)
	echo $acc_name $Diff >> $balDiffFile
done < /home/$USER/accountList.txt

sort -k2 -n -r $balDiffFile | tee $balDiffFile > /dev/null

echo The users with highest change in account balance...
cat $balDiffFile


# Displays expenditure report for current month

expFile="/home/$USER/expenditure.txt"
> $expFile

while read acc_name others
do
	month=$(date '+%Y-%m')
	totalexp=0
	# Assuming 30 days a month...
	for val in {01..30}
	do
		trans=$(cat /home/$acc_name/Transaction_History.txt | grep "$month-$val" | cut -d" " -f2)
		#echo $month-$val
		exp=0
		for tran in $trans
		do
			if [ ${tran:0:1} == "-" ]
			then
				exp=$(bc <<< $exp+${tran:1})
			fi
		done
		totalexp=$(bc <<< $totalexp+$exp)
	done
	avgexp=$(bc <<< $totalexp/30.0)
	echo $acc_name $avgexp >> $expFile
done < /home/$USER/accountList.txt

echo The average expenditure of each Account Holder for this month...
cat $expFile
