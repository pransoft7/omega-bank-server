#!/bin/bash

echo alias genUser=\'bash genUser.sh\' >> .bashrc
echo alias permit=\'bash permit.sh\' >> .bashrc
echo alias updateBranch=\'bash updateBranch.sh\' >> .bashrc
echo alias allotInterest=\'bash allotInterest.sh\' >> .bashrc
echo alias makeTransaction=\'bash makeTransaction.sh\' >> .bashrc

source .bashrc
