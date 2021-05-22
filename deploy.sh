#!/bin/bash

# read input (convert to lowercase)
# 'all' means deploy all functions
function_name=$(echo "$1" | tr '[:upper:]' '[:lower:]')

# store working directory
base_dir="$PWD"
target_dir="`dirname \"$0\"`/src"

# test target
if [ "$function_name" = "test" ]; then
cd "$target_dir"
echo "this would build target test in " "$PWD"
cd "$base_dir"
fi

# deploy sendMessage
if [ "$function_name" = "all" -o "$function_name" = "sendmessage" ]; then
cd "$target_dir"
gcloud functions deploy sendMessage --runtime=ruby27 --trigger-http --entry-point=send_message --region=europe-west3
cd "$base_dir"
fi