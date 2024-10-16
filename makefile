# Default values (can be overridden when invoking make)
SOURCE_DIR ?= /path/to/source
TARGET_DIR ?= /path/to/backups
BACKUP_INTERVAL ?= 60 # in minutes

# Cron job command
CRON_JOB = */$(BACKUP_INTERVAL) * * * * ./backup.sh -m 10 $(SOURCE_DIR) $(TARGET_DIR) > /dev/null 2>&1

install:
	@echo "Installing cron job..."
	# Check if the cron job already exists
	( crontab -l | grep -v -F "$(SOURCE_DIR)" ; echo "$(CRON_JOB)" ) | crontab -
	@echo "Cron job installed: $(CRON_JOB)"

uninstall:
	@echo "Removing cron job..."
	# Remove the cron job
	( crontab -l | grep -v -F "$(SOURCE_DIR)" ) | crontab -
	@echo "Cron job removed."

.PHONY: install_backup uninstall_backup
