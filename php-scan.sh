#!/bin/bash

# Define recipients' email addresses (comma-separated)
recipients="bsinkule@otava.com,dpupeza@otava.com,pchandra@otava.tech,sadhikari@otava.tech"

# Maven verify command
composer update > php_report.txt 2>&1
# Capture the exit status of the Maven command
composer_exit_status=$?
#mvn_exit_status=0
# Define email subject and body
subject="PHP Composer Update Report"
body="Please find the attached Composer Update report for OCP PHP code."

# If Maven command was successful, send the email with the report as an attachment
if [ $composer_exit_status -eq 0 ]; then
  # Generate the report file name based on timestamp

  # Send the email with the report as an attachment
  echo "$body" | mutt -s "$subject" "$recipients"  -a php_report.txt

  # Remove the temporary report file

else
  # If Maven command failed, send a simple notification email
  echo "Composer Update command failed. Please check the build." | mutt -s "Composer Update failed" "$recipients"
fi
