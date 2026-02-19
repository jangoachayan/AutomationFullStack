import pytest
import asyncio
from unittest.mock import MagicMock, patch
from app.core.watchdog import MQTTWatchdog
import time

@pytest.mark.asyncio
async def test_watchdog_detects_dead_device():
    # Setup
    with patch("app.core.watchdog.mqtt.Client") as mock_mqtt:
        watchdog = MQTTWatchdog()
        watchdog.client = MagicMock()
        
        # Simulate a heartbeat received 130 seconds ago (Threshold is 120s)
        old_time = time.time() - 130
        watchdog.heartbeats["homeassistant/binary_sensor/knx_heartbeat_1/state"] = old_time
        
        # Mock logging to capture the alert
        with patch("app.core.watchdog.logger") as mock_logger:
            await watchdog.check_health()
            
            # Verify CRITICAL warning was logged
            mock_logger.warning.assert_called_with(
                f"CRITICAL: Device Dead detected. Topic: homeassistant/binary_sensor/knx_heartbeat_1/state. Last seen 130.0s ago."
            )

@pytest.mark.asyncio
async def test_watchdog_ignores_healthy_device():
    # Setup
    with patch("app.core.watchdog.mqtt.Client") as mock_mqtt:
        watchdog = MQTTWatchdog()
        
        # Simulate heartbeat received 10s ago
        recent_time = time.time() - 10
        watchdog.heartbeats["homeassistant/binary_sensor/knx_heartbeat_1/state"] = recent_time
        
        with patch("app.core.watchdog.logger") as mock_logger:
            await watchdog.check_health()
            
            # Verify NO warning logged
            mock_logger.warning.assert_not_called()
