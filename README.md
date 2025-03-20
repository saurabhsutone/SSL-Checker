# SSL Checker - PowerShell Script

This PowerShell script allows users to check the **SSL certificate details** of one or multiple domains. It retrieves important information such as:

- **Certificate Issuer (CA)**
- **Common Name (CN)**
- **Subject Alternative Names (SANs)**
- **Validity Period (Start & Expiry Date)**
- **Days Remaining Until Expiry**
- **Serial Number**
- **Signature Algorithm**
- **Certificate Chain**

## Features
- Supports multiple domain checks in one execution
- Automatically converts `http://` URLs to `https://`
- Fetches and displays all relevant SSL certificate details
- Identifies certificates nearing expiration

## Prerequisites
- Windows PowerShell
- Internet connectivity
- Run PowerShell as Administrator for best results

## Installation & Download
1. **Download the script manually:**
   - Click on the **"Code"** button in the GitHub repository.
   - Select **"Download ZIP"** and extract it.
   - Navigate to the extracted folder.

2. **Clone the repository using Git:**
   ```powershell
   git clone https://github.com/<your-username>/SSL-Checker.git
