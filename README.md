# Backup Scripts

This repository contains two Bash scripts for creating and restoring backups.
The scripts allow you to manage backups of a specified directory while keeping
track of the maximum number of backups you want to retain.

## Table of Contents

- [Script 1: Backup Script](#script-1-backup-script)
- [Script 2: Restore Script](#script-2-restore-script)
- [Usage](#usage)
- [Options](#options)
- [Requirements](#requirements)
- [Running in Cron Jobs](#running-in-cron-jobs)

## Script 1: Backup Script

This script creates a backup of a specified source directory.
It supports incremental backups by only copying files that have changed since the last backup.

### Usage

```bash
./backup.sh [options] <source dir> <target dir>
```

### Options

- `-m <max>`: Set the maximum number of backups to keep (default: 10).
- `-h`, `--help`: Display the help message.

## Script 2: Restore Script

This script restores a backup from a specified directory to a target directory.
You can choose to restore the latest backup or select from a list of available backups.

### Usage

```bash
./restore.sh [options] <backup dir> <target dir>
```

### Options

- `-i`, `--interactive`: Prompts the user to choose which backup to restore.
- `-h`, `--help`: Display the help message.

## Usage

1. **Creating a Backup**:
   - Run the backup script by specifying the source and target directories.
   - Example:
     ```bash
     ./backup.sh /path/to/source /path/to/backups
     ```

2. **Restoring a Backup**:
   - Run the restore script by specifying the backup directory and the target directory.
   - Example:
     ```bash
     ./restore.sh /path/to/backups /path/to/restore
     ```

## Requirements

- Bash shell
- Basic Unix commands (like `cp`, `mkdir`, `find`, etc.)

## Running in Cron Jobs

To automate the backup process, you can set up a cron job using the provided Makefile.
This allows you to run the backup script at specified intervals.

2. **Install the Cron Job**:
`SOURCE_DIR`: Path to directory to backup 
`TARGET_DIR`: Path to backup directory (Where the backup will be created)
`BACKUP_INTERVAL`: Interval (in minutes) for the cron Job

```bash
make install SOURCE_DIR=/path/to/source TARGET_DIR=/path/to/backups BACKUP_INTERVAL=30
```

3. **Unistall the Cron Job**:
```bash
make unistall SOURCE_DIR=/path/to/source
```

4. **Manual installation**
Run script every 3rd Friday of the month at 12:31 AM
```bash
deno

```
--- 
