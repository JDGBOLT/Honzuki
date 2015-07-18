#!/usr/bin/env bash

# Usage: ./create-post.sh (chapter number) (translated title)

# Grab story from ncode and reformat it into markdown
NCODE="n4830bu"
NCODE_FILE=$(curl http://ncode.syosetu.com/$NCODE/$1/)
TITLE=$(echo "$NCODE_FILE" | grep novel_subtitle | sed -e "s/<p class=\"novel_subtitle\">/[$2](original: /g" | sed -e "s/<\/p>/)/g")
CONTENT=$(echo "$NCODE_FILE" | pup '#novel_honbun' | sed -e 's/<.*>//g' | sed -e 's/^ 「/> \[**** \"\"\](original: 「/g' | sed -e  's/^ /[](original: /g' | sed -e 's/$/)/g' | sed -e 's/^\[\](original: )$//g' | sed -e 's/^)$//g')

# Set the information required for the header and file information
POST_PADDED=$(printf "%03d" $1)
POST_FILE="$(date +"%F")-$POST_PADDED-$(echo $2 | tr '[A-Z]' '[a-z]' | tr " " "-").md"
POST_TITLE="$POST_PADDED - $2"
POST_DATE=$(date +"%FT%T%:z")
HEADER=$(cat _templates/chapter | sed -e "s/{{ title }}/$POST_TITLE/g" | sed -e "s/{{ date }}/$POST_DATE/g")

# Write the entire story as a draft to be translated, edited, and later published
echo "$HEADER"$'\n\n'"$TITLE"$'\n'"$CONTENT" > _drafts/$POST_FILE
