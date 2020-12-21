#!/bin/zsh

# Script to collect data
# and put the data into outputfile
# version,source,destination,complete,amount,error,status
# the status value is created for errors for easier searching in munki report
# the output file is not created if the Arq.app does not live in the /Applications folder
# the output file is removed if there is not Arq.app in the /Applications folder.

CWD=$(dirname $0)
CACHEDIR="$CWD/cache/"
OUTPUT_FILE="${CACHEDIR}ARQbackup.txt"
SEPARATOR=' = '
MOST_RECENT_LOG="`ls -t /Library/Logs/ArqAgent/backup | head -n1`"
THELOG="/Library/Logs/ArqAgent/backup/${MOST_RECENT_LOG}"
# Test for QRQbackup app exists
if [ -d "/Applications/Arq.app" ]; then

# Create cache dir if it does not exist
mkdir -p "${CACHEDIR}"

# Business logic goes here:

# Get the ARQ Version #
VERSION="`cat $THELOG | grep version | awk '{print $6}'`"
# END Get the ARQ Version #

# Get the Storage Target Location #
DESTINATION="`cat $THELOG | grep location | awk '{print $7}' | tr -d '(,)' `"
# END Get the Storage Target Location #

# Get the Backup Source #
SOURCE="`cat $THELOG | grep backed | awk '{print $4}' | tr -d :`"
# END Get the Backup Source #

# Get the Amount Backed Up #
AMOUNT="`cat $THELOG | grep bytes | awk '{print $5}' | tr -d ','`"
printf -v GIGABYTES "%.2f" $(bc -l <<< $(( $AMOUNT / 1000000000 )))
GBAMOUNT="$GIGABYTES GB"
# END Get the Amount Backed Up #

# Get the date of backup ending #
SDATE="`cat $THELOG | grep ended | awk '{print $1}'`"
# END Get the date of backup ending #

# Get the time of backup ending #
STIME="`cat $THELOG | grep ended | awk '{print $2}'`"
# END Get the time of backup ending #

#Get the Unix TimeStamp of the ending #
DATETIME="$SDATE $STIME"
#date -d '2012-03-22 22:00:05 EDT' +%s
#date -j -f "%Y-%m-%d %H-%M-%S" '2020-12-17 11-30-15' +%s
TIMESTAMP="`date -j -f "%d-%b-%Y %H:%M:%S" "$DATETIME" +%s`"
#END Get the Unix TimeStamp of the ending #

# Get only the first Error Explanation (-m 1)#
REASON="`cat $THELOG | grep -m 1 ror: | cut -f5- -d' '`"
# END Get the Error Explanation #

# Set the Error Status #
if [ "$REASON" != "" ]; then
STATUS="Error"
fi
#END set the Error status

# Output data here
echo "version${SEPARATOR}$VERSION" > ${OUTPUT_FILE}
echo "source${SEPARATOR}$SOURCE" >> ${OUTPUT_FILE}
echo "destination${SEPARATOR}$DESTINATION" >> ${OUTPUT_FILE}
echo "completed${SEPARATOR}$TIMESTAMP" >> ${OUTPUT_FILE}
echo "amount${SEPARATOR}$GBAMOUNT" >> ${OUTPUT_FILE}
echo "error${SEPARATOR}$REASON" >> ${OUTPUT_FILE}
echo "status${SEPARATOR}$STATUS" >> ${OUTPUT_FILE}
#END Output data

else
# There is no App so Remove the output file
rm -rf $OUTPUT_FILE
fi
