#! /bin/bash
interactive=false

#parse options
while [[ $# -gt 0 ]]; do
    case $1 in
    -h | --help)
        echo "Usage: $0 [options] <backup dir> <target dir>"
        echo "Options:"
        echo "  -i <interactive>    Prompts user which backup to restore"
        echo "  -h                  Display this help message"
        exit 0
        ;;
    -i | --interactive)
        interactive=true
        shift
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
    echo "Error: missing backup directory"
    echo "run '$0 -h' for help"
    exit 1
fi

target=$(realpath -s "$1")
backup_info="$source/backup_info.txt"

# TODO: parameter validation

backups=()
while read -r line; do
    line=$(realpath -s "$source/$line")
    if [ -d "$line" ]; then
        backups+=("$line")
    else
        sed -i "/$line/d" "$backup_info"
    fi
done <"$backup_info"

# prompt user to select which backup to restore or restore the latest backup
if [ $interactive = true ]; then
    echo "Select which backup to restore:"
    select backup in "$(realpath --relative-to="$source" ${backups[@]})"; do
        if [ -n "$backup" ]; then
            break
        fi
    done
else
    backup=${backups[-1]}
fi

cp -r "$backup" "$target"
