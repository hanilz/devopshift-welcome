from fastapi import FastAPI
from models import read_server_dict, add_new_server, ServerStatus

app = FastAPI()
# servers = {"srv1": True, "srv2": False}

@app.get("/")
def home():
    return "hello there"

@app.get("/servers")
def get_servers(server_name: str = None):
    servers = read_server_dict()
    if server_name:
        if server_name in servers:
            return f"server {server_name} status: {servers[server_name]}"
        else:
            return f"Server {server_name} doesn't exist!"
    return servers

@app.post("/servers")
def post_server(server_name = None):
    if server_name:
        add_new_server(server_name)
        return server_name + " added."
    raise ValueError("No server name given")

@app.get("/error")
def error():
    raise ValueError("damn")
