#!/bin/bash

# Script to collect data
# and put the data into outputfile
# version,source,destination,complete,amount,error,status
# the status value is created for errors for easier searching in munki report
# the output file is not created if the Arq.app does not live in the /Applications folder
# the output file is removed if there is not Arq.app in the /Applications folder.

# Test for QRQbackup app exists
if [ -d "/Applications/Arq.app" ]; then

CWD=$(dirname "$0")
CACHEDIR="$CWD/cache/"
OUTPUT_FILE="${CACHEDIR}ARQbackup.txt"
SEPARATOR=' = '
MAJORVER=$(defaults read /Applications/Arq.app/Contents/Info.plist CFBundleShortVersionString | cut -c1)
#echo $MAJORVER

# Set the log location based on version number#
if [[ $MAJORVER = "6" ]]; then
LOGLOC="/Library/Logs/ArqAgent/backup"
elif [[ $MAJORVER = "7" ]]; then
LOGLOC="/Library/Application Support/ArqAgent/logs/backup"
fi
MOST_RECENT_LOG="$(ls -t "$LOGLOC" | head -n1)"
THELOG="${LOGLOC}/${MOST_RECENT_LOG}"
# END Set the log location#

VERSION="$(cat "$THELOG" | grep version | awk '{print $6}')"

# Create cache dir if it does not exist
mkdir -p "${CACHEDIR}"

# Get the Storage Target Location #
DESTINATION="$(cat "$THELOG" | grep location | awk '{print $7}' | tr -d '(,)' )"
# END Get the Storage Target Location #

# Get the Backup Source based on version number#
if [[ $MAJORVER = "6" ]]; then
SOURCE="$(cat "$THELOG" | grep backed | awk '{$1=$2=$3=""; print $0}' | cut -d : -f 1)"
elif [[ $MAJORVER = "7" ]]; then
FULLSOURCE="$(cat "$THELOG" | grep backed | awk '{$1=$2=$3=""; print $0}' | cut -d : -f 1)"
SOURCE="${FULLSOURCE##*/}"
fi
# END Get the Backup Source #

# Get the Amount Uploaded
if [[ $MAJORVER = "7" ]]; then
GBAMOUNT="$(cat "$THELOG" | grep compressed')': | awk '{print $7 $8}' | tr -d ',')"
fi
# END Get the Amount Uploaded#
#echo $GBAMOUNT

# Get the Total Amount Stored
if [[ $MAJORVER = "7" ]]; then
GBSTORED="$(cat "$THELOG" | grep after | awk '{print $9 $10}')"
fi
# END Get the Total Amount Stored#
#echo $GBSTORED

# Get the date of backup ending #
SDATE="$(cat "$THELOG" | grep ended | awk '{print $1}')"
# END Get the date of backup ending #
#echo $SDATE

# Get the time of backup ending #
STIME="$(cat "$THELOG" | grep ended | awk '{print $2}')"
# END Get the time of backup ending #
#echo $STIME 

#Get the Unix TimeStamp of the ending #
DATETIME="$SDATE $STIME"
#TIMESTAMP="`date -j -f "%d-%b-%Y %H:%M:%S" "$DATETIME" +%s`"
TIMESTAMP="$(date -j -f "%d-%b-%Y %H:%M:%S" "$DATETIME" +%s)"
#END Get the Unix TimeStamp of the ending #
#echo $TIMESTAMP

# Get only the first Error Explanation (-m 1)#
REASON="$(cat "$THELOG" | grep -m 1 ror: | cut -f5- -d' ')"
# END Get the Error Explanation #

# Set the Error Status #
if [ "$REASON" != "" ]; then
STATUS="Error"
fi
#END set the Error status

# Output data here
echo "version${SEPARATOR}$VERSION" > "${OUTPUT_FILE}"
echo "source${SEPARATOR}$SOURCE" >> "${OUTPUT_FILE}"
echo "destination${SEPARATOR}$DESTINATION" >> "${OUTPUT_FILE}"
echo "completed${SEPARATOR}$TIMESTAMP" >> "${OUTPUT_FILE}"
echo "amount${SEPARATOR}$GBAMOUNT" >> "${OUTPUT_FILE}"
echo "stored${SEPARATOR}$GBSTORED" >> "${OUTPUT_FILE}"
echo "error${SEPARATOR}$REASON" >> "${OUTPUT_FILE}"
echo "status${SEPARATOR}$STATUS" >> "${OUTPUT_FILE}"
#END Output data

else
# There is no App so Remove the output file
rm -rf "${OUTPUT_FILE}"
fi
