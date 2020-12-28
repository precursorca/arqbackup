# Arqbackup module

> v. 1.0.2 
> December 28, 2020  
> Alex Narvey / Precursor.ca  

![ARQbackup Module Report](ARQbackup_Module.png)

Reports on Arqbackup backup information

Retrieves information from the most recent log file /Library/Logs/ArqAgent/backup.

The following information is stored in the table:

* version - The Arqbackup.app version
* source - Name of source
* destination - Name of destination
* completed - Timestamp of last run
* amount - Amount in MB or GB
* error - Error message (the first error message, if any)
* status = Marked as 'error' if there is an error (for easier search in MR.)

## Notes

An output file is only created if the Arq.app exists in the /Applications folder.
The output file is removed if the Arq.app no longer exists so that new records will not be created.

## Current
Current refers to backups run within the last 24 hours

## Stale
Stale refers to backups more than 24 hours old

## Errors
Errors is independent of whether the backup is fresh or stale.

## Updates

* December 28, 2020 Version 1.0.2  Script can now handle spaces in Source name and amounts less than 1 GB.
* December 21, 2020 Version 1.0.1  Made changes and modifications for efficienty suggested by John Eberle (Tuxudo)
* December 21, 2020 Version 1.0 

## Contributors
* Alex Narvey

—
Alex Narvey
precursor.ca
