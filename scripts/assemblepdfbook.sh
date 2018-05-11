#!/bin/bash

# Extract the current info
echo "Reading existing file"
pdftk "$1" dump_data > index.info.original

# Remove any existing bookmarks from the file
grep -v Bookmark index.info.original > index.info

# Loop through the csv and create the bookmark lines
echo "Creating bookmarks"
awk 'BEGIN{FS="\t"}{print "BookmarkBegin\nBookmarkTitle: "$2"\nBookmarkLevel: "$1"\nBookmarkPageNumber: "$4""}' $2 >> index.info

# Add the bookmarks to the file
echo "Creating output file"
pdftk "$1" update_info index.info output output_toc.pdf
