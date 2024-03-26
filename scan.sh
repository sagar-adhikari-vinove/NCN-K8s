#!/bin/bash

# Define recipients' email addresses (comma-separated)
recipients="bsinkule@otava.com,dpupeza@otava.com,pchandra@otava.com,sadhikari@otava.tech"

# Maven verify command
mvn verify > mvn_output.txt 2>&1
# Capture the exit status of the Maven command
mvn_exit_status=$?
#mvn_exit_status=0
cp pasco-product-web/target/dependency-check-report.html pasco-product-web/target/pasco-product-web-report.html
cp pasco-contact-web/target/dependency-check-report.html pasco-contact-web/target/pasco-contact-web-report.html
cp pasco-customer-web/target/dependency-check-report.html pasco-customer-web/target/pasco-customer-web-report.html
cp pasco-partner-web/target/dependency-check-report.html pasco-partner-web/target/pasco-partner-web-report.html
cp pasco-subscription-web/target/dependency-check-report.html pasco-subscription-web/target/pasco-subscription-web-report.html
# Define email subject and body
subject="Maven Verify Report"
body="Please find the attached Maven verify report for OCP Java code."

product_report="pasco-product-web/target"
# If Maven command was successful, send the email with the report as an attachment
if [ $mvn_exit_status -eq 0 ]; then
  # Generate the report file name based on timestamp

  # Send the email with the report as an attachment
  echo "$body" | mutt -s "maven verify report" "$recipients"  -a pasco-product-web/target/pasco-product-web-report.html -a pasco-contact-web/target/pasco-contact-web-report.html -a pasco-customer-web/target/pasco-customer-web-report.html -a pasco-subscription-web/target/pasco-subscription-web-report.html -a pasco-partner-web/target/pasco-partner-web-report.html

  # Remove the temporary report file
  
else
  # If Maven command failed, send a simple notification email
  echo "Maven verify command failed. Please check the build." | mutt -s "Maven Verify Failed" "$recipients" -a mvn_output.txt
fi
