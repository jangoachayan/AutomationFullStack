from fastapi import FastAPI, Request, Depends
import yaml
from pydantic import BaseModel
import os
import asyncio
from app.core.ace import ace
from app.core.watchdog import watchdog

app = FastAPI()

class BrandingConfig(BaseModel):
    brand_id: str
    primary_color: str
    logo_url: str
    support_endpoint: str
    init: bool = False

def load_config():
    config_path = "config.yaml"
    if not os.path.exists(config_path):
        return {"branding": {"brand_id": "DEFAULT", "primary_color": "#000000", "logo_url": "", "support_endpoint": ""}, "init": False}
    
    with open(config_path, "r") as f:
        return yaml.safe_load(f)

@app.on_event("startup")
async def startup_event():
    # Start the MQTT Watchdog in background
    asyncio.create_task(watchdog.start())

@app.get("/")
def read_root(request: Request):
    client_ip = request.client.host
    profile = ace.get_connection_profile(client_ip)
    return {
        "message": "Automation FullStack Backend Running",
        "connection_profile": profile
    }

@app.get("/config/branding", response_model=BrandingConfig)
def get_branding():
    config = load_config()
    branding = config.get("branding", {})
    init_val = config.get("init", False)
    # Flatten structure for response model provided
    response = branding.copy()
    response["init"] = init_val
    return BrandingConfig(**response)

@app.get("/health")
def health_check():
    return {"status": "ok"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

