#!/bin/sh -l
## A bash script for the job to push select files to pastebin.com
## DIR_TO_UPLOAD -- The path to the dir to search files in
## EXT_WHITELIST -- A comma seperated string whitelisting file extensions

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

IFS=',' read -r -a EXTENSIONS <<< "$EXT_WHITELIST"

echo "PASTEBIN_API_KEY is set"
echo "Directory to upload: $DIR_TO_UPLOAD"
echo "Allowed extensions: ${EXTENSIONS[@]}"
echo '### :pencil: Report' >> $GITHUB_STEP_SUMMARY
echo '| Pastebin Link :link: | File :page_facing_up: |' >> $GITHUB_STEP_SUMMARY
echo '| :---                 | :----:                |' >> $GITHUB_STEP_SUMMARY
echo "----"

for EXT in "${EXTENSIONS[@]}"; do
  while IFS= read -r FILE; do
    echo "Uploading $FILE to Pastebin"
    FILE_CONTENTS=$(cat "$FILE")
    RESPONSE=$(curl -s -X POST \
      -d "api_dev_key=$PASTEBIN_API_KEY" \
      -d "api_paste_code=$FILE_CONTENTS" \
      -d "api_option=paste" \
      "https://pastebin.com/api/api_post.php")

    echo "Response from Pastebin: $RESPONSE"
    echo "| $RESPONSE | $FILE |" >> $GITHUB_STEP_SUMMARY
  done < <(find "$DIR_TO_UPLOAD" -type f -name "*.$EXT")
done

exit 0