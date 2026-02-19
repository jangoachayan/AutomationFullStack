# InfluxDB v2 Schema Design: Multi-Tenant Diagnostics

## Strategy: Tag-Based Segregation
We utilize a single global bucket `telemetry_prod` and distinguish tenants via high-cardinality tags. This allows efficient aggregation across the entire fleet while maintaining data isolation via properly scoped Flux tokens.

## Schema Definition

### Bucket
- **Name**: `telemetry_prod`
- **Retention**: 90 Days (Hot), Downsample to 1 Year (Cold)

### Measurement: `heartbeats`
Contains periodic health checks from edge nodes.

#### Tags (Indexed Metadata)
| Tag Key | Description | Example Values |
| :--- | :--- | :--- |
| `site_id` | **Primary Key**. Unique identifier for the deployment. | `Kannur`, `Dubai_Villa_1` |
| `region` | Geographic grouping for latency analysis. | `South-India`, `ME-North` |
| `plan_tier` | SLA Level for alerting priority. | `Gold` (5m response), `Silver` (24h) |
| `protocol` | The subsystem being monitored. | `knx`, `zigbee`, `mqtt` |

#### Fields (Values)
| Field Key | Type | Description |
| :--- | :--- | :--- |
| `status` | Integer | `1` (OK), `0` (Error) |
| `latency_ms` | Float | Round-trip time to cloud broker. |
| `cpu_load` | Float | CPU usage of the Sentinel container. |

## Query Logic (Deadman)
The alerting engine groups by `site_id` before applying the deadman check. This ensures that if *Kannur* goes offline, it triggers a specific alert for *Kannur*, independent of other sites.
