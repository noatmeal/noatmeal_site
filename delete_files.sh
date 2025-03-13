#!/bin/bash

response=$(
  curl \
    -H "Authorization: Bearer $NEOCITIES_API_KEY" \
    "https://neocities.org/api/list"
)

if [[ $(echo "$response" | jq -r '.result') != "success" ]]; then
  echo "Error: Failed to fetch file list from Neocities API."
  exit 1
fi

filenames=($(echo "$response" | jq -r '.files[] | select(.is_directory == false) | select(.path != "index.html") | .path'))

if [ ${#filenames[@]} -eq 0 ]; then
  echo "No files to delete."
  exit 0
fi

curl_command="curl -H 'Authorization: Bearer $NEOCITIES_API_KEY'"

for FILENAME in "${filenames[@]}"; do
  curl_command+=" -d 'filenames[]=$FILENAME'"
done

curl_command+=" 'https://neocities.org/api/delete'"

echo "Running:"
echo "$curl_command"

eval "$curl_command"
