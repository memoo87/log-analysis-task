# Web Server Log Analysis

This task analyzes a simulated web server access log using a Bash script. It extracts key metrics, identifies patterns, and provides actionable suggestions to improve system performance and reliability.

## 📁 Files Included

- `web_server_access_log.log` — Simulated access log (~3000+ requests over 2 weeks)
- `analyze_log.sh` — Bash script to analyze the log file and extract insights
- `Log_Analysis_Report.pdf` — Summary report containing findings and suggestions

## ⚙️ How to Run the Script

### Requirements:
- Bash environment 

### Steps:
1. Make the script executable:
    ```bash
    chmod +x analyze_log.sh
    ```

2. Run the script:
    ```bash
    ./analyze_log.sh
    ```

Ensure the log file (`web_server_access_log.log`) is in the same directory as the script.

## 🔍 Analysis Features

- Total requests, GET and POST breakdown
- Unique IPs with request counts
- Failure request count and failure rate
- Most active IP addresses (overall, GET, POST)
- Daily and hourly request trends
- Breakdown of HTTP status codes
- Failure patterns by day and hour

## 📌 Suggestions for Improvement

Based on the analysis output, you’ll receive:
- Performance improvement suggestions
- Failure reduction strategies
- Security and traffic pattern alerts
