servers = {"srv1": True, "srv2": False}

srv = input("Please enter server name to check: ")

if not srv:
    raise ValueError("Invalid Input!")
elif srv in servers:
    if servers[srv]:
        print(f"Server {srv} is running.")
    else:
        print(f"Server {srv} is not running.")
else:
    print(f"Server {srv} is not recognized.")
