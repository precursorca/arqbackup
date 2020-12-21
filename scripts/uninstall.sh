#!/bin/bash

# Remove arqbackup script
rm -f "${MUNKIPATH}preflight.d/arqbackup.sh"

# Remove arqbackup.txt file
rm -f "${MUNKIPATH}preflight.d/cache/arqbackup.txt"
