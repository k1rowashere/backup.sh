# Default values (can be overridden when invoking make)
SOURCE_DIR ?= /path/to/source
TARGET_DIR ?= /path/to/backups
BACKUP_INTERVAL ?= 60 # in minutes

ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

# Cron job command
CRON_JOB = */$(BACKUP_INTERVAL) * * * * $(HOME)/backup.sh -m 10 $(SOURCE_DIR) $(TARGET_DIR) > /dev/null 2>&1

install:
	@echo "Installing cron job..."
	cp "$(ROOT_DIR)/backup.sh" "$(HOME)"
	# Check if the cron job already exists
	( crontab -l | grep -v -F "$(SOURCE_DIR)" ; echo "$(CRON_JOB)" ) | crontab -
	@echo "Cron job installed: $(CRON_JOB)"

uninstall:
	@echo "Removing cron job..."
	rm "$(HOME)/backup.sh"
	# Remove the cron job
	( crontab -l | grep -v -F "$(SOURCE_DIR)" ) | crontab -
	@echo "Cron job removed."

.PHONY: install_backup uninstall_backup
