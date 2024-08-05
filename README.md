# Day One Classic to Markdown Converter

Convert your Day One Classic entries to Markdown.

## Summary
This script uses `plutil` to extract Entry Text and Tags from each Day One entry. A new file is created for each entry in a new export folder within the same directory using the Creation Date timestamp and an MD5 hash.

The following keys are included in the export:
- Creation Date
- Entry Text
- Tags

## Limitations
The primary goal of this script was to extract text content of a Day One Classic journal instead of metadata or media. The following are not included in the exported Markdown files:
- Activity
- Creator
- Ignore Step Count
- Location
- Music
- Publish URL
- Starred
- Step Count
- Time Zone
- UUID
- Weather

## Usage
1. Find your Day One Classic entries files from Day One > Settings… > Sync.
2. Copy this folder somewhere it can be modified without affecting the original files.
3. Copy the script.sh file into the folder.
4. Give the script permissions to execute by running `chmod u+x ./script.sh`.
5. Run the script using `./script.sh`.
6. Observe a new folder is created called exports where your entries were converted into Markdown.

## Day One Classic Entries
![Day One Classic Sync Settings](README/day-one-classic-settings-sync.jpeg)

Day One Classic stores entries as plists (Property Lists), an XML format popular on Apple software for quickly storing data without having to manage a database. Day One 2 moved to SQLite3. If you have other media in your journal, they will be stored in separate folders.

## Alternatives
- [karyslav](https://github.com/karyslav) uses AppleScript in their [DayOneClassicMD-to-Separete-MarkDown-files](https://github.com/karyslav/DayOneClassicMD-to-Separete-MarkDown-files/tree/main) script.
- If you're using Day One 2, use [indyandie](https://github.com/Indyandie)'s [Last Day](https://github.com/Indyandie/last-day) script.
