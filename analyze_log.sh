#!/bin/bash

LOG_FILE="web server access log.log"

echo "=== Log File Analysis ==="

# 1. Request Counts
total_requests=$(wc -l < "$LOG_FILE")
get_requests=$(grep -c '"GET ' "$LOG_FILE")
post_requests=$(grep -c '"POST ' "$LOG_FILE")
echo "Total Requests: $total_requests"
echo "GET Requests: $get_requests"
echo "POST Requests: $post_requests"

# 2. Unique IP Addresses
unique_ips=$(awk '{print $1}' "$LOG_FILE" | sort | uniq)
unique_ip_count=$(echo "$unique_ips" | wc -l)
echo "Unique IPs: $unique_ip_count"
echo "Requests by IP and Method:"
for ip in $unique_ips; do
    ip_get=$(grep "^$ip " "$LOG_FILE" | grep -c '"GET ')
    ip_post=$(grep "^$ip " "$LOG_FILE" | grep -c '"POST ')
    echo "$ip - GET: $ip_get, POST: $ip_post"
done

# 3. Failure Requests (4xx or 5xx)
failures=$(awk '{if ($9 ~ /^[45]/) print}' "$LOG_FILE" | wc -l)
fail_percent=$(awk -v f="$failures" -v t="$total_requests" 'BEGIN {printf "%.2f", (f/t)*100}')
echo "Failed Requests: $failures"
echo "Failure Percentage: $fail_percent%"

# 4. Top User (Most Active IP)
top_ip=$(awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -1)
echo "Most Active IP: $top_ip"

# 5. Daily Request Averages
days=$(awk -F'[:[]' '{print $2}' "$LOG_FILE" | cut -d: -f1 | sort | uniq | wc -l)
avg_per_day=$(awk -v total="$total_requests" -v days="$days" 'BEGIN {printf "%.2f", total/days}')
echo "Average Requests per Day: $avg_per_day"

# 6. Failure Analysis by Day
echo "Failures per Day:"
awk '{if ($9 ~ /^[45]/) print $4}' "$LOG_FILE" | cut -d: -f1 | cut -c 2- | sort | uniq -c | sort -nr

# Additional: Requests by Hour
echo "Requests per Hour:"
awk -F'[:[]' '{print $2":"$3}' "$LOG_FILE" | sort | uniq -c | sort -n

# Status Codes Breakdown
echo "Status Code Breakdown:"
awk '{print $9}' "$LOG_FILE" | sort | grep -E '^[0-9]{3}$' | uniq -c | sort -nr

# Most Active IP by Method
echo "Top IP by Method:"
echo "GET:"
grep '"GET ' "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr | head -1
echo "POST:"
grep '"POST ' "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr | head -1

# Patterns in Failure Requests by Hour/Day
echo "Failure Patterns by Hour:"
awk '{if ($9 ~ /^[45]/) print $4}' "$LOG_FILE" | cut -d: -f2 | sort | uniq -c | sort -nr
echo "Failure Patterns by Day:"
awk '{if ($9 ~ /^[45]/) print $4}' "$LOG_FILE" | cut -d: -f1 | cut -c 2- | sort | uniq -c | sort -nr
