#!/usr/bin/env bash
## Requires kramdown and athenapdf

infile='VPCodecISOMediaFileFormatBinding.md'
outfile='vp-codec-iso-media-file-format-binding-latest'

printf "\nConverting Markdown to HTML ...\n"

kramdown --template html-template ../${infile} | \
  # Change image path to parent, and make empty <th> truly empty
  sed -e 's/src="images/src="\.\.\/images/g' \
  -re 's|<th>\xc2\xa0</th>|<th></th>|g' \
  > ${outfile}.html

printf "\nHTML finished.\n\n"

printf "\nConverting HTML to PDF ...\n\n"

## athenapdf can't handle filesystem paths
cp -r ../images .

docker run --security-opt seccomp=unconfined \
  --rm -v $(pwd):/converted/ arachnysdocker/athenapdf athenapdf --no-cache \
  ${outfile}.html ${outfile}.pdf

rm -rf images

printf "\nPDF finished.\n\n"
