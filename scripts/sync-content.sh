#!/bin/bash

# This is a cleanup script to be run after vendir syncs the content from the remote content repository.
# Vendir creates a folder and syncs it with the specified folder in the remote repo.
# This script then moves that content to the root of the src/pages directory, before removing the empty content directory.

# Sync content from remote repositories to a new folder called temporary-content
# as specified in vendir.yml
vendir sync

# Move files from temporary-content subfolders to their relevant place in the actual content folder structure
mv temporary-content/finetuning/docs/* main-content/subnets/subnet-37-finetuning/

# Clean up temporary-content directory
rm -r temporary-content