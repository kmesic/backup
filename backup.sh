#!/bin/bash

USER="/Users/kenan-mesic"

# Define which folders to back up
SOURCE=(
"Documents"
"Desktop"
)

# Define where you want to put your archive files
# SanDisk SSD
BACKUP_PATH="/Volumes/Extreme SSD"
# Seagate Backup Path
# BACKUP_PATH="/Volumes/Seagate Expansion Drive"


# SHELL FORMATING
bold=$(tput bold)
normal=$(tput sgr0)

# checking if path exists, otherwise exit
if [ -d "$BACKUP_PATH" ]; then
    echo "Backing up to ${bold}$BACKUP_PATH${normal}"
    echo ""
else
    echo "No directory $BACKUP_PATH found. Exiting...\n"
    echo ""
    exit 1
fi

echo "Creating temp directory to store tar files!";
# Define the tempdir where we'll create the TAR file
TEMPDIR=$(mktemp -d /tmp/usb-backup.XXXXXXXXXX)

echo ""

# Loop through your source folders
for i in "${SOURCE[@]}"
do
	# Set the filename where we'll put the backup TAR file
	BACKUPFILE=$TEMPDIR/${i//\/}.tar

    echo "Taring source: $User/$i"
	# Create the TAR archive
	tar -cvpf $BACKUPFILE -C $USER $i
    echo ""

    # short rsync explanation
    # -v = verbose
    # -a = archive mode
    # -l = copy symlinks as symlinks (yep, we want this)
    # -P = show progress during transfer
    # -o = preserve owner (super-user only)
    # -g = preserve group

	# Sync the TAR file to the USB disk, removing the TAR
	# file from your main disk when finished
	rsync -avlPog --remove-source-files "$BACKUPFILE" "$BACKUP_PATH"

    # Untar the file and delete the tar from the backup
    echo "Untar content in Backup and remove tar file"
    TAR_BACKUP="$BACKUP_PATH/${i//\/}.tar"
    tar -xvf "$TAR_BACKUP" -C "$BACKUP_PATH"
    rm -r "$TAR_BACKUP"

    echo ""

done

# When all source folders have been archived and copied to
# the destination disk, remove the tempdir
rm -r $TEMPDIR

echo "${bold}Backup Complete!${normal}"

# Exit successfully
exit 0