#!/usr/bin/env bash
#
# Convert Day One Classic plist entries to Markdown.
# Github: https://github.com/ketanketanketan/day-one-classic-to-markdown
# Author: Ketan Patel

set -euo pipefail

# Start
start_time=`date`
echo "Started at: $start_time"

PATH_TO_ENTRIES="entries"
ENTRIES=$(ls $PATH_TO_ENTRIES)
PATH_TO_EXPORT="export"

# Create directory
# Recreate the export directory every run.
if [[ ! $(find . -type d -name "$PATH_TO_EXPORT") ]]; then
  mkdir "$PATH_TO_EXPORT"
else
  rm -rf "$PATH_TO_EXPORT"
  mkdir "$PATH_TO_EXPORT"
fi

#######################################
# Generate Markdown files.
# Globals:
#   PATH_TO_ENTRIES
#   PATH_TO_EXPORT
# Arguments:
#   entry
# Outputs:
#   Creates Markdown file per entry.
#######################################
function generate_markdown() {
  local entry="$PATH_TO_ENTRIES/$1"

  local extracted_created_date=$(plutil -extract "Creation Date" raw $entry)
  local extracted_entry_text=$(plutil -extract "Entry Text" raw $entry)

  local has_tags=false
  if plutil -extract "Tags" xml1 -o /dev/null "$entry" &>/dev/null; then
    has_tags=true
  fi

  # HAX: Is there a better way to include newlines when appending a string with a value?
  local extracted_tags="tags:"
  if [[ "$has_tags" == true ]]; then
    local entry_tag_count=$(plutil -extract "Tags" raw $entry)
    if [[ $entry_tag_count > 0 ]]; then
      for ((tag_index = 0; tag_index < entry_tag_count; tag_index++)); do
        local extracted_tag=$(plutil -extract "Tags".$tag_index raw $entry | tr ' ' '-')
        extracted_tags="$extracted_tags
  - $extracted_tag"
      done
    fi
  fi

  local entry_md5=$(md5 -q $entry)
  output_file_name=$(echo $extracted_created_date | sed 's/:/-/g')
  output_file="$PATH_TO_EXPORT/$output_file_name-$entry_md5.md"

  local markdown="---
date: $extracted_created_date
$extracted_tags
---

$extracted_entry_text"

  echo "$markdown" > $output_file

  echo "✓ $entry exported to $output_file"
}

#######################################
# Provides a summary of results after running the script.
# Globals:
#   PATH_TO_ENTRIES
#   PATH_TO_EXPORT
# Arguments:
#   None
# Outputs:
#   Prints statistics to console.
#######################################
function summary() {
  local entries_count=$(ls $PATH_TO_ENTRIES | wc -l)
  local export_count=$(ls $PATH_TO_EXPORT | wc -l)
  echo "SUMMARY"
  echo "------------------------"
  echo "Entries: $entries_count"
  echo "Exported: $export_count"
}

for entry in ${ENTRIES[@]}; do
  generate_markdown $entry
done

summary

# End
end_time=`date`
echo "Completed at: $end_time"

start_time=$(date -j -f "%a %b %d %H:%M:%S %Z %Y" "$start_time" "+%s")
end_time=$(date -j -f "%a %b %d %H:%M:%S %Z %Y" "$end_time" "+%s")

DURATION=$(($end_time - $start_time))
echo "Duration: $DURATION seconds"
