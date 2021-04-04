# :floppy_disk: Backup Script

This is a bash script that backups a Mac computer onto an external drive. 

This script will iterate through all the source folders/files specified. Tar each one up and store in a temp directory. Then it will transfer all the tars over to the drive. It uses rsync to do this. After that it will untar each one in the drive and then delete the tar both from the external drive and the computer.

## Config
All configs can be made in the [backup.sh](./backup.sh)

- **$USER**: Which user on the computer should the script cd into and transfer files from.

- **$SOURCE**: All folders/files to transfer

- **$BACKUP_PATH**: Path to the external drive to backup the files to



