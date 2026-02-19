import json
import os

def get_branding_config():
    config_path = os.path.join(os.path.dirname(__file__), '../../config/branding_config.json')
    try:
        with open(config_path, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        return {"error": "Branding configuration not found"}
