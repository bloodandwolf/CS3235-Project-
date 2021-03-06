#!/bin/bash


#Filepaths
LTESnifferFile="database.txt"
CELL_SEARCH="./cell_search"
UE="ue.conf"
UEFile=ue.txt
UserInterface="./main.py"

#Bands to search on
arr=( 3 7 8 )


#Name of the variables in LTESnifferFile
Frequency="Frequency"
PhysicalCellID="PHYSICALCELLID"
PSSPower="PSS Power"

#Name of the variables in UEFile
MCC="MCC"
MNC="MNC"

#MCC and MNC
MCCCountryCode=525
MNC01="SingTel"
MNC02="SingTel - G18"
MNC03="M1"
MNC05="StarHub"
MNC06="STarHub"
MNC07="Grid"
MNCOthers="Others"

for i in "${arr[@]}"
do
	echo "First loop $i"	
	$CELL_SEARCH -b $i
 
	while [ ! -f $LTESnifferFile ]
	do
		sleep 10;
		echo "Waiting for file \n"
	done

	#Reading the LTESnifferFile to get the different frequency
	while read line
	do

		IFS=','
		for x in $line
		do
			#Remove leading whitespace before the words
			x=`echo $x | sed -e 's/^[ \t]*//'`
			if [[ $x =~ "$Frequency"* ]]
			then
				FrequencyValue=`echo $x | sed 's/^'$Frequency' //'`
				echo "New FREq $FrequencyValue"

			elif [[ $x =~ "$PhysicalCellID"* ]]
			then
				PhysicalCellIDValue=`echo $x | sed 's/^'$PhysicalCellID' //'`
				echo "NEW PSS $PhysicalCellIDValue"
			elif [[ $x =~ "$PSSPower"* ]]
			then
				PSSPowerValue=`echo $x | sed 's/^'$PSSPower' //'`
				echo "NEW PSS $PSSPowerValue"
			fi
		done

		#Start of running the UE
		echo "freq val = $FrequencyValue"
		calculateFreq=`echo "scale = 2; $FrequencyValue * 1000000" | bc`
		calculateFreq=`printf "%.0f" $calculateFreq`
		echo $calculateFreq
		#Remember the sed is for mac 0S
		#sed -i '.bak' '23s/.*/dl_freq = '$calculateFreq'/' $UE
		sed -i	 '23s/.*/dl_freq = '$calculateFreq'/' $UE
		#./ue ue.conf
		#sleep 600

		if [ -f $UEFile ]
		then	
			#Read file to get MCC and MNC
			IFS=' '
			read -r MCCandMNC < $UEFile
			echo $MCCandMNC
			IFS=','
			for y in $MCCandMNC
			do
				y=`echo $y | sed -e 's/^[ \t]*//'`
				if [[ $y =~ "$MCC"* ]]
				then
					MCCValue=`echo $y | sed 's/^'$MCC' //'`
					echo $MCCValue
				elif [[ $y =~ "$MNC"* ]]
				then
					MNCValue=`echo $y | sed 's/^'$MNC' //'`
					echo $MNCValue
					case "$MNCValue" in 
						1)
							CarrierValue=$MNC01
							;;
						2)
							CarrierValue=$MNC02
							;;
						3)
							CarrierValue=$MNC03
							;;
						5)
							CarrierValue=$MNC05
							;;
						6)
							CarrierValue=$MNC06
							;;
						7)
							CarrierValue=$MNC07
							;;
						*)
							CarrierValue=$MNCOthers
							;;
					esac
								
				fi
			done
			php WriteToDatabase.php $FrequencyValue $MCCValue $MNCValue $CarrierValue $PhysicalCellIDValue $PSSPowerValue
		fi
	done < $LTESnifferFile

	rm -f $UEfile
	rm -f $LTESnifferFile
done

$UserInterface

