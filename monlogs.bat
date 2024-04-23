@echo off

rem Log file path
set LOG_FILE=C:\inetpub\logs\LogFiles

rem Report file path
set REPORT_FILE=C:\users\Administrator\Desktop\Monitored_logs\failed_login_report.txt

rem Regular expression pattern for failed logins
set PATTERN="(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}) - - \[(.*?)\] \"(GET|POST|PUT|DELETE|HEAD|OPTIONS) (\S+) HTTP/\d\.\d\" (401|403|404|500|502)"

rem Path to Python executable
set PYTHON_PATH=C:\Users\Administrator\AppData\Local\Programs\Python\Python312\python.exe

rem Check if it's Thursday
%PYTHON_PATH% -c "import datetime; exit(datetime.datetime.now().weekday() != 3)" > nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo It's not Thursday. No report will be generated.
    exit /b
)

%PYTHON_PATH% -c "import re, datetime; failed_logins = []; with open('%LOG_FILE%', 'r') as f: log_data = f.readlines(); for entry in log_data: match = re.search(r'%PATTERN%', entry); if match: ip_address, date_str, request_method, request_uri, status_code = match.groups(); date_obj = datetime.datetime.strptime(date_str, '%%d/%%b/%%Y:%%H:%%M:%%S'); if date_obj.weekday() == 3 and date_obj.hour >= 0 and date_obj.hour < 24: failed_logins.append((ip_address, date_str, request_method, request_uri, status_code)); if failed_logins: report_content = 'Failed Login Report\\n\\n'; for ip_address, date_str, request_method, request_uri, status_code in failed_logins: report_content += f'IP Address: {ip_address}, Date: {date_str}, {request_method} {request_uri} - HTTP Status Code: {status_code}\\n'; with open('%REPORT_FILE%', 'w') as f: f.write(report_content); print(f'Failed Login Report generated at {REPORT_FILE}'); else: print('No failed logins detected.')" > nul 2>&1
