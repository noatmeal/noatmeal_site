#!/bin/bash

filepaths=()

for FILE in "site"/*; do
  filepaths+=("$FILE")
done

if [ ${#filepaths[@]} -eq 0 ]; then
  echo "No files to push."
  exit 0
fi

curl_command="curl -H 'Authorization: Bearer $NEOCITIES_API_KEY'"

for FILEPATH in "${filepaths[@]}"; do
  curl_command+=" -F '$FILEPATH=@$FILEPATH'"
done

curl_command+=" 'https://neocities.org/api/upload'"

echo "Running:"
echo "$curl_command"

# eval "$curl_command"
