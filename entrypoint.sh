#!/bin/sh -l
## A bash script for the job to push select files to pastebin.com
## DIR_TO_UPLOAD -- The path to the dir to search files in
## EXT_WHITELIST -- A comma separated string whitelisting file extensions

DIR_TO_UPLOAD=$1
EXT_WHITELIST=$2

if [ -z "$PASTEBIN_API_KEY" ]; then
  echo "Error: PASTEBIN_API_KEY is not set"
  exit 1
fi

if [ ! -d "$DIR_TO_UPLOAD" ]; then
  echo "Error: Directory '$DIR_TO_UPLOAD' does not exist"
  exit 1
fi

EXTENSIONS=$(echo $EXT_WHITELIST | tr ',' ' ')

echo "PASTEBIN_API_KEY is set"
echo "Directory to upload: $DIR_TO_UPLOAD"
echo "Allowed extensions: $EXTENSIONS"
echo '### :pencil: Report' >> $GITHUB_STEP_SUMMARY
echo '| Pastebin Link :link: | File :page_facing_up: |' >> $GITHUB_STEP_SUMMARY
echo '| :---                 | :----:                |' >> $GITHUB_STEP_SUMMARY
echo "----"

for EXT in $EXTENSIONS; do
  find "$DIR_TO_UPLOAD" -type f -name "*.$EXT" | while IFS= read -r FILE; do
    echo "Uploading $FILE to Pastebin"
    FILE_CONTENTS=$(cat "$FILE")
    RESPONSE=$(curl -s -X POST \
      --data-urlencode "api_dev_key=$PASTEBIN_API_KEY" \
      --data-urlencode "api_paste_code=$FILE_CONTENTS" \
      --data-urlencode "api_option=paste" \
      "https://pastebin.com/api/api_post.php")

    echo "Response from Pastebin: $RESPONSE"
    if echo "$RESPONSE" | grep -q "Bad API request"; then
      echo "| $RESPONSE | $FILE |" >> $GITHUB_STEP_SUMMARY
    else
      echo "| [$RESPONSE]($RESPONSE) | $FILE |" >> $GITHUB_STEP_SUMMARY
    fi
  done
done

exit 0
