#!/bin/bash

# This is a cleanup script to be run after vendir syncs the content from the remote content repository.
# Vendir creates a folder and syncs it with the specified folder in the remote repo.
# This script then moves that content to the root of the src/pages directory, before removing the empty content directory.

# Sync content from remote repository
vendir sync

# Move folding files to src/pages/subnet-25
mv temporary-content/finetuning/docs/* main-content/subnets/subnet-37-finetuning/

# Clean up empty content directory
rm -r temporary-content