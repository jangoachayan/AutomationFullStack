from fastapi import FastAPI
from app.core.branding import get_branding_config

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Automation FullStack Backend Running"}

@app.get("/config/branding")
def get_branding():
    return get_branding_config()

@app.get("/health")
def health_check():
    return {"status": "ok"}
