import httpx

try:
    id = int(input("Please enter the id of the wanted user: "))
except Exception:
    raise ValueError("Invalid Input!")
try:
    res = httpx.get(f"https://jsonplaceholder.typicode.com/users/{id}")
    if res.status_code == 200:
        user_dict = res.json()
        name = user_dict["name"]
        email = user_dict["email"]

        address = user_dict["address"]
        street = address["street"]
        city = address["city"]

        print(f"User {id} data:\nname: {name}\nemail: {email}\naddress: {street}, {city}")
    elif res.status_code == 404:
        print(f"User {id} not found")
    elif res.status_code == 500:
        print("Server error, please try again later.")
except Exception as e:
    print(e)