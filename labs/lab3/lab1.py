# Scenario
# You are building a DevOps script that integrates with a cloud monitoring API. The script will:
# Fetch system metrics (CPU & Memory usage) using an authenticated API request.
# Handle API failures, including timeouts, authentication errors, and network issues.
# Implement a retry mechanism for temporary failures.
#
# Instructions
# Use Authentication
#
#
# Fetch data from https://api.example.com/system/metrics (Assume it requires an API key).
# Use headers = {"Authorization": "Bearer YOUR_API_KEY"}.
# Pass Query Parameters
#
#
# Include a parameter to fetch only CPU and memory metrics (?metrics=cpu,memory).
# Implement Error Handling
#
#
# Handle 401 Unauthorized errors (Print "Invalid API Key.").
# Handle 500 Internal Server Error (Print "Server is currently down.").
# Implement retries (Up to 3 attempts with a delay if the API fails).
from time import sleep

import httpx

wait_time = 2.0
retries_count = 0
max_retries = 3
message = ""

url = "https://api.example.com/system/metrics"
headers = {"Authorization": "Bearer YOUR_API_KEY"}
params = {"metrics": "cpu,memory"}


print("Fetching system metrics...")


def retry(retries_count: int, message: str) -> int:
    retries_count += 1
    print(f"Attempt {retries_count} failed: {message}")
    if retries_count < max_retries:
        print(f"Retrying in {wait_time} seconds...")
        sleep(wait_time)
    else:
        print("All retry attempts failed.")
    return retries_count


while retries_count < max_retries:
    try:
        res = httpx.get(url, params=params, headers=headers)
        if res.status_code == 200:
            print("Successful!")
            break
        elif res.status_code == 401:
            message = "Invalid API Key."
        elif res.status_code == 500:
            message = "Server is currently down."
        retries_count = retry(retries_count, message)
    except Exception as e:
        retries_count = retry(retries_count, str(e))



