import subprocess

# task 1
p = subprocess.run(["ls", "-l", "/var/log/aewrg"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
print(f"stdout of ls -l /var/log is: {p.stdout.decode()}")
print(f"stderr of ls -l /var/log is: {p.stderr.decode()}")

# task 2 - works on MacOS
command = "launchctl list"
nginx_status = subprocess.run(command.split(), stdout=subprocess.PIPE)
print(f"stdout of {command} is: {nginx_status.stdout.decode()}")
