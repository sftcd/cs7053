#!/bin/bash
# --------------------------------------------------------------------
# Recursively find pdfs from the directory given as the first argument,
# otherwise search the current directory.
# Use exiftool and qpdf (both must be installed and locatable on $PATH)
# to strip all top-level metadata from PDFs.
#
# Note - This only removes file-level metadata, not any metadata
# in embedded images, etc.
#
# Code is provided as-is, I take no responsibility for its use,
# and I make no guarantee that this code works
# or makes your PDFs "safe," whatever that means to you.
#
# You may need to enable execution of this script before using,
# eg. chmod +x remove-pdf-metadata.sh
#
# example:
# clean current directory:
# >>> ./remove-pdf-metadata.sh
#
# clean specific directory:
# >>> ./remove-pdf-metadata.sh some/other/directory
# From: https://gist.github.com/sneakers-the-rat/172e8679b824a3871decd262ed3f59c6
# --------------------------------------------------------------------


# loop through all PDFs in first argument ($1),
# or use '.' (this directory) if not given
DIR="${1:-.}"

echo "Cleaning PDFs in directory $DIR"

# use find to locate files, pip to while read to get the
# whole line instead of space delimited
# Note -- this will find pdfs recursively!!
find $DIR -type f -name "*.pdf" | while read -r i
do

  # output file as original filename with suffix _clean.pdf
  TMP=${i%.*}_clean.pdf

  # remove the temporary file if it already exists
  if [ -f "$TMP" ]; then
      rm "$TMP";
  fi

  exiftool -q -q -all:all= "$i" -o "$TMP"
  qpdf --linearize --replace-input "$TMP"
  mv "$TMP" "$i"
  echo "Processed ${i}"

done


