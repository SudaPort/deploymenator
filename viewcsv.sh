#!/bin/bash
# Purpose: Read Comma Separated CSV File
# Author: Vivek Gite under GPL v2.0+
# ------------------------------------------
INPUT=CNAME.cvs
OLDIFS=$IFS
IFS=','
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read flname dob ssn tel status
do
	echo "Name : $Name"
	echo "RecordType : $RecordType"
	echo "ZoneName : $ZoneName"
	echo "ResourceGroupName : $ResourceGroupName"
	echo "TTL : $TTL"
    echo "Value : $Value"
done < $INPUT
IFS=$OLDIFS

INPUT2=SANDCNAME.cvs
OLDIFS2=$IFS2
IFS2=','
[ ! -f $INPUT2 ] && { echo "$INPUT2 file not found"; exit 99; }
while read flname dob ssn tel status
do
	echo "Name2 : $Name"
	echo "RecordType2 : $RecordType"
	echo "ZoneName2 : $ZoneName"
	echo "ResourceGroupName2 : $ResourceGroupName"
	echo "TTL2 : $TTL"
    echo "Value2 : $Value"
done < $INPUT2
IFS=$OLDIFS2