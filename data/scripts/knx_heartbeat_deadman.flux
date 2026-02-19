import "influxdata/influxdb/monitor"
import "influxdata/influxdb/schema"

// Define the data stream from the global bucket
// Schema: Tag-Based Segregation
// Bucket: telemetry_prod
// Measurement: heartbeats
// Tags: site_id, region, plan_tier
option task = {name: "Global Site Down Monitor", every: 1m}

data = from(bucket: "telemetry_prod")
    |> range(start: -10m)
    |> filter(fn: (r) => r["_measurement"] == "heartbeats")
    |> filter(fn: (r) => r["protocol"] == "knx")
    // Vital: Group by site_id to ensure deadman checks are isolated per site
    |> group(columns: ["site_id", "region", "plan_tier"])

// Check logic for Grafana/InfluxDB Alerting
check = {
    _check_id: "site_down_check",
    _check_name: "Site Down Alert",
    _type: "deadman",
    tags: {},
}

// Deadman function: Triggers if no data received for 5 minutes
data
    |> monitor.deadman(
        t: experimental.subDuration(d: 5m, from: now()),
        fn: (r) => r["_level"] == "crit",
        messageFn: (r) => "CRITICAL: Site ${r.site_id} (Region: ${r.region}, Plan: ${r.plan_tier}) is offline. No telemetry for 5 mins."
    )
