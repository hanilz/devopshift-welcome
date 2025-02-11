from pydantic import BaseModel, ValidationError
import json


class ServerStatusResponse(BaseModel):
    server_name: str
    server_status: str | bool


class ServerStatus(BaseModel):
    online: bool
    cpus: int
    ram: int


def read_server_dict() -> dict[str: ServerStatus]:
    with open("servers.txt", "r") as f:
        servers: dict[str: ServerStatus] = {}
        for line in f.readlines():
            if line.strip():
                json_object = json.loads(line)
                try:
                    server_name = list(json_object.keys())[0]
                    server_status = ServerStatus(**json.loads(json_object[server_name]))
                    servers[server_name] = server_status
                except ValidationError:
                    pass
    return servers


def add_new_server(server_name: str):
    with open("servers.txt", "a") as f:
        new_server = {server_name: ServerStatus(online=True, cpus=6, ram=10).model_dump_json()}
        f.write("\n")
        f.write(json.dumps(new_server))
