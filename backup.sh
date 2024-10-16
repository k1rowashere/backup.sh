#! /bin/bash

max_backup_count=10

#parse options
while [[ $# -gt 0 ]]; do
    case $1 in
    -m | --max)
        max_backup_count=$2
        shift
        shift
        ;;
    -h | --help)
        echo "Usage: $0 [options] <source dir> <target dir>"
        echo "Options:"
        echo "  -m <max>       Maximum number of backups to keep (default: 10)"
        echo "  -h             Display this help message"
        exit 0
        ;;
    *)
        if [ $# -eq 2 ]; then break; fi # last argument is the backup directory

        echo "Unknown option: $key"
        echo "run '$0 -h' for help"
        exit 1
        ;;
    esac
done

if [ $# -lt 1 ]; then
    echo "Error: missing source directory"
    echo "run '$0 -h' for help"
    exit 1
fi

source=$(realpath -s "$1")
shift

if [ $# -lt 1 ]; then
    echo "Error: missing target directory"
    echo "run '$0 -h' for help"
    exit 1
fi

# TODO: parameter validation

target=$(realpath -s "$1")
old_backup=""
new_backup="$target/$(date --iso-8601=s)"
backup_info="$target/backup_info.txt"

mkdir -p "$target"
if [[ ! -f "$backup_info" ]]; then
    cp -r "$source" "$new_backup"
    echo ./$(realpath --relative-to="$target" "$new_backup") >"$backup_info"
    echo "Initial backup"
    exit 0
fi

# find the latest valid backup_dir
while read -r line; do
    line=$(realpath -s "$target/$line")
    if [ -d "$line" ]; then
        old_backup="$line"
    else
        # remove invalid backup directories
        sed -i "/$line/d" "$backup_info"
    fi
done <"$backup_info"

has_changes=0

# copy all changed/added files
for file in $(find "$source" -type f | xargs realpath -s --relative-to="$source"); do
    if [ ! -f "$old_backup/$file" ] || [[ $(stat -c %Y "$old_backup/$file") -lt $(stat -c %Y "$source/$file") ]]; then
        mkdir -p "$(dirname "$new_backup/$file")"
        echo "$source/$file --> $new_backup/$file"
        cp "$source/$file" "$(dirname "$new_backup/$file")"
        has_changes=1
    fi
done

if [[ $has_changes -eq 0 ]]; then
    echo "No changes since last backup"
    exit 0
fi

# hard link all unchanged files
for file in $(find "$old_backup" -type f | xargs realpath -s --relative-to="$old_backup"); do
    if [ -f "$source/$file" ] && [ ! -f "$new_backup/$file" ]; then
        echo "$source/$file ~~> $new_backup/$file"
        ln "$old_backup/$file" "$(dirname "$new_backup/$file")"
    fi
done

echo $(realpath --relative-to="$target" "$new_backup") >>"$backup_info"

# remove the oldest backup, if the number of backups exceeds max_backup_count
while [[ $(wc -l <"$backup_info") -gt $max_backup_count ]]; do
    oldest_backup_dir = $(head -n 1 "$backup_info")
    rm -rf "$oldest_backup_dir"
    sed -i "1d" "$backup_info"
done
