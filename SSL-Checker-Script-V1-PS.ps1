# Prompt user to enter a single URL or multiple URLs (comma-separated)
$inputUrls = Read-Host "Enter URL(s) (comma-separated for multiple)"

# Convert input to an array and ensure HTTPS is used
$domains = $inputUrls -split "," | ForEach-Object { $_.Trim() -replace "^http://", "https://" -replace "^https://", "" }

# Function to get SSL details
function Get-SSLDetails {
    param ($domain)

    $url = "https://$domain"

    try {
        $port = 443
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        $tcpClient.Connect($domain, $port)
        $sslStream = New-Object System.Net.Security.SslStream($tcpClient.GetStream(), $false, ({ $true }))
        $sslStream.AuthenticateAsClient($domain)
        $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($sslStream.RemoteCertificate)

        # Get certificate details
        $subject = $cert.Subject
        $issuer = $cert.Issuer
        $validFrom = $cert.NotBefore
        $validTo = $cert.NotAfter
        $serialNumber = $cert.SerialNumber
        $signatureAlgorithm = $cert.SignatureAlgorithm.FriendlyName
        $daysRemaining = ($validTo - (Get-Date)).Days

        # Extract SAN (Subject Alternative Names)
        $sanList = ($cert.Extensions | Where-Object { $_.Oid.FriendlyName -eq "Subject Alternative Name" }).Format(0) -split "`n" | ForEach-Object { $_.Trim() }
        
        # Display certificate details
        Write-Output ""
        Write-Output "---------------------------"
        Write-Output "Domain: $domain"
        Write-Output "Certificate Issuer (CA): $issuer"
        Write-Output "Common Name (CN): $subject"
        Write-Output "Subject Alternative Names (SANs): $($sanList -join ', ')"
        Write-Output "Valid From: $validFrom"
        Write-Output "Expires On: $validTo"
        Write-Output "The certificate will expire in $daysRemaining days."
        Write-Output "Serial Number: $serialNumber"
        Write-Output "Signature Algorithm: $signatureAlgorithm"
        Write-Output "---------------------------"

        # Get Certificate Chain
        Write-Output "Certificate Chain:"
        foreach ($certChain in $sslStream.RemoteCertificate.Issuer.Split(",")) {
            Write-Output "   - $certChain"
        }

        $tcpClient.Close()
    } catch {
        Write-Output "Failed to check SSL for $domain"
    }
}

# Loop through each domain and check SSL details
foreach ($domain in $domains) {
    Get-SSLDetails -domain $domain
}
