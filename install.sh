#!/bin/bash

# arqbackup controller
CTL="${BASEURL}index.php?/module/arqbackup/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/arqbackup.sh" -o "${MUNKIPATH}preflight.d/arqbackup.sh"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/arqbackup.sh"

	# Set preference to include this file in the preflight check
	setreportpref "arqbackup" "${CACHEPATH}arqbackup.txt"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/arqbackup.sh"

	# Signal that we had an error
	ERR=1
fi
