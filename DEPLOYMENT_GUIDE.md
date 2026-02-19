# AutomationFullStack Deployment Guide

## Target Environment
- **Site**: Kannur
- **Hardware**: HP EliteDesk 800 G5
- **OS**: Proxmox VE (Debian-based)

## Prerequisites
1. **GitHub Access**: Ensure you have pulled the latest `implementation_plan` and `main` branch.
2. **Secrets**: Populate `infra/secrets.yml` with your:
   - `proxmox_password`
   - `cloudflare_api_token`

---

## Part 1: Terraform (Cloudflare Tunnel & mTLS)

**Objective**: Provision the "Zero-Trust" tunnel object and enforce mTLS policies.

1. Navigate to the Terraform directory:
   ```bash
   cd infra/terraform
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Plan the deployment (Verify the changes):
   ```bash
   terraform plan -out=tfplan \
     -var="cloudflare_api_token=<YOUR_TOKEN>" \
     -var="cloudflare_account_id=<YOUR_ACC_ID>"
   ```

4. Apply the configuration:
   ```bash
   terraform apply tfplan
   ```
   > **Note**: Copy the `tunnel_token` output. You will need this for the Ansible step.

---

## Part 2: Ansible (Proxmox & Container Provisioning)

**Objective**: Deploy the Home Assistant LXC and the Cloudflared service.

1. Navigate to the Infra directory:
   ```bash
   cd ../
   ```

2. Export the Tunnel Token:
   ```powershell
   # PowerShell
   $env:CLOUDFLARE_TUNNEL_TOKEN="<PASTE_TOKEN_HERE>"
   # or Bash
   export CLOUDFLARE_TUNNEL_TOKEN="<PASTE_TOKEN_HERE>"
   ```

3. Run the Playbook:
   ```bash
   ansible-playbook playbook.yml -i inventory
   ```

---

## Part 3: Verification

1. **Check Tunnel Status**:
   Visit the Cloudflare Zero Trust Dashboard > Tunnels. Ensure 'home-automation-edge' is **HEALTHY**.

2. **Test mTLS**:
   Try accessing `https://ha.ats-automation.com` from a device *without* the client certificate. You should be **BLOCKED**.

3. **Verify Dashboard**:
   Open the Flutter PWA. Ensure the "Manara" theme loads by default.
