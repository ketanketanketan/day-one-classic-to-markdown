#!/usr/bin/env bash
set -euo pipefail

# Start
start_time=`date`
echo "Started at: $start_time"

directory="entries"
files=$(ls $directory)

# Create directory
# Recreate the export directory every run.
if [[ ! $(find . -type d -name "export") ]]; then
  mkdir export
else
  rm -rf export
  mkdir export
fi

# Generate Markdown Files
function generate_markdown() {
  local file="$directory/$1"

  extracted_created_date=$(plutil -extract "Creation Date" raw $file)
  extracted_entry_text=$(plutil -extract "Entry Text" raw $file)

  has_tags=false
  if plutil -extract "Tags" xml1 -o /dev/null "$file" &>/dev/null; then
    has_tags=true
  else
    has_tags=false
  fi

  # HAX: Unfortunately like 43 blow is space sensative. I should use `printf` later.
  if [[ "$has_tags" == true ]]; then
    file_tag_count=$(plutil -extract "Tags" raw $file)
    extracted_tags="tags:"
    if [[ $file_tag_count > 0 ]]; then
      for ((tag_index = 0; tag_index < file_tag_count; tag_index++)); do
        extracted_tags="$extracted_tags
  - $(plutil -extract "Tags".$tag_index raw $file)"
      done
    fi
  fi

  local file_md5=$(md5 -q $file)
  file_output_name=$(echo $extracted_created_date | sed 's/:/-/g')
  file_output="export/$file_output_name-$file_md5.md"
  
  local markdown="---
date: $extracted_created_date
$extracted_tags
---

$extracted_entry_text
  "

  echo "$markdown" > $file_output

  echo "✓ $file exported to $file_output"
}

function summary() {
  local entries_count=$(ls entries | wc -l)
  local export_count=$(ls export | wc -l)
  echo "SUMMARY"
  echo "------------------------"
  echo "Entries: $entries_count"
  echo "Exported: $export_count"
}

for file in ${files[@]}; do
  generate_markdown $file
done

summary

# End
end_time=`date`
echo "Completed at: $end_time"

start_time=$(date -j -f "%a %b %d %H:%M:%S %Z %Y" "$start_time" "+%s")
end_time=$(date -j -f "%a %b %d %H:%M:%S %Z %Y" "$end_time" "+%s")

duration=$(($end_time - $start_time))
echo "Duration: $duration seconds"
