#!/bin/bash

# This is a cleanup script to be run after vendir syncs the content from the remote content repository.
# Vendir creates a folder and syncs it with the specified folder in the remote repo.
# This script then moves that content to the root of the src/pages directory, before removing the empty content directory.

# Sync content from remote repository
vendir sync

# Move content files to the root of src/pages
mv src/content/macrocosmos-content/src/pages/* src/pages/

# Move folding files to src/pages/subnet-25
mv src/content/folding/docs/* src/pages/subnet-25/

# Clean up empty content directory
rm -r src/content