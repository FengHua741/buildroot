#!/bin/bash
# Post-build script to clean up resource migration markers

TARGET_DIR="$1"

echo "Cleaning up resource migration markers..."
rm -f "${TARGET_DIR}/var/lib/resources_expanded"
rm -f "${TARGET_DIR}/var/lib/resources_migrated"
rm -f "${TARGET_DIR}/var/lib/resources_partitioned"
rm -f "${TARGET_DIR}/tmp/reboot_after_expand"

echo "Markers cleaned successfully."
