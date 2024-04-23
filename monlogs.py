import re
import datetime
import os

# Log file path
log_file_path = "/var/log/apache2/access.log"

# Report file path
report_file_path = "/path/to/failed_login_report.txt"

# Regular expression pattern for failed logins
failed_login_pattern = r'(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}) - - \[(.*?)\] "(GET|POST|PUT|DELETE|HEAD|OPTIONS) (\S+) HTTP/\d\.\d" (401|403|404|500|502)'

def generate_report():
    with open(log_file_path, "r") as f:
        log_data = f.readlines()

    failed_logins = []
    for entry in log_data:
        match = re.search(failed_login_pattern, entry)
        if match:
            ip_address, date_str, request_method, request_uri, status_code = match.groups()
            failed_logins.append((ip_address, date_str, request_method, request_uri, status_code))

    if failed_logins:
        report_content = "Failed Login Report\n\n"
        for ip_address, date_str, request_method, request_uri, status_code in failed_logins:
            report_content += f"IP Address: {ip_address}, Date: {date_str}, {request_method} {request_uri} - HTTP Status Code: {status_code}\n"

        with open(report_file_path, "w") as f:
            f.write(report_content)
        print(f"Failed Login Report generated at {report_file_path}")
    else:
        print("No failed logins detected.")

if __name__ == "__main__":
    # Check if it's Thursday and the time is 11:59 PM
    today = datetime.datetime.now()
    if today.weekday() == 3 and today.hour == 23 and today.minute == 59:
        generate_report()
    else:
        print("It's not Thursday at 11:59 PM. No report will be generated.")
