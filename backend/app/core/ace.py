from ipaddress import ip_network, ip_address

class AdaptiveConnectionEngine:
    def __init__(self):
        # Local subnets for ultra-low latency mode
        # MikroTik hAP ac3 (Home Theater) - Standard default: 192.168.88.0/24
        # HPE Aruba 2930F - Standard enterprise range example: 10.0.10.0/24
        # Users can override these in config if needed
        self.local_subnets = [
            ip_network("192.168.88.0/24"), # MikroTik
            ip_network("10.0.10.0/24"),   # HPE Aruba
            ip_network("127.0.0.1/32"),    # Localhost
            ip_network("172.30.32.0/23")   # Home Assistant Internal Docker Network
        ]

    def is_local_connection(self, client_ip: str) -> bool:
        """
        Determines if the client IP belongs to a local ultra-low latency subnet.
        """
        try:
            ip = ip_address(client_ip)
            for subnet in self.local_subnets:
                if ip in subnet:
                    return True
            return False
        except ValueError:
            return False

    def get_connection_profile(self, client_ip: str) -> dict:
        is_local = self.is_local_connection(client_ip)
        return {
            "mode": "ultra_low_latency" if is_local else "cloud_optimized",
            "compression": not is_local,
            "keepalive_interval": 5 if is_local else 60,
            "ip": client_ip
        }

ace = AdaptiveConnectionEngine()
