import asyncio
import logging
import json
import time
import os
import paho.mqtt.client as mqtt

logger = logging.getLogger(__name__)

class MQTTWatchdog:
    def __init__(self, broker_host="core-mosquitto", broker_port=1883, username=None, password=None):
        self.broker_host = os.getenv("MQTT_HOST", broker_host)
        self.broker_port = int(os.getenv("MQTT_PORT", broker_port))
        self.username = os.getenv("MQTT_USER", username)
        self.password = os.getenv("MQTT_PASSWORD", password)
        
        self.client = mqtt.Client(callback_api_version=mqtt.CallbackAPIVersion.VERSION2)
        if self.username and self.password:
            self.client.username_pw_set(self.username, self.password)
            
        self.client.on_connect = self.on_connect
        self.client.on_message = self.on_message
        
        self.heartbeats = {}
        self.threshold = 120 # seconds

    def on_connect(self, client, userdata, flags, rc, properties=None):
        logger.info(f"Connected to MQTT Broker with code {rc}")
        # Subscribe to heartbeats
        client.subscribe("homeassistant/binary_sensor/knx_heartbeat_*/state")
        client.subscribe("homeassistant/sensor/zigbee_coordinator_availability/state")

    def on_message(self, client, userdata, msg):
        try:
            topic = msg.topic
            payload = msg.payload.decode()
            timestamp = time.time()
            self.heartbeats[topic] = timestamp
            logger.debug(f"Heartbeat received: {topic} at {timestamp}")
        except Exception as e:
            logger.error(f"Error processing message: {e}")

    async def start(self):
        logger.info("Starting MQTT Watchdog...")
        try:
            self.client.connect_async(self.broker_host, self.broker_port, 60)
            self.client.loop_start()
            
            while True:
                await self.check_health()
                await asyncio.sleep(10)
        except Exception as e:
            logger.error(f"MQTT Watchdog failed: {e}")

    async def check_health(self):
        current_time = time.time()
        for topic, last_seen in self.heartbeats.items():
            if current_time - last_seen > self.threshold:
                logger.warning(f"CRITICAL: Device Dead detected. Topic: {topic}. Last seen {current_time - last_seen}s ago.")
                # Logic to publish alert/diagnostics would go here

watchdog = MQTTWatchdog()
