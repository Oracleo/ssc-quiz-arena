# Android Signing Key Generation Script (Windows)
# Run this ONCE and back up the keystore file securely!

Write-Host "==================================="
Write-Host "SSC Quiz Arena - Android Key Setup"
Write-Host "==================================="
Write-Host ""

# Check if keystore already exists
if (Test-Path "android\app\release.keystore") {
    Write-Host "❌ ERROR: release.keystore already exists!"
    Write-Host "   Do not regenerate - this will break existing releases."
    Write-Host "   If lost, restore from your backup."
    exit 1
}

# Get inputs
$keystorePassword = Read-Host "Enter keystore password" -AsSecureString
$keystorePasswordConfirm = Read-Host "Confirm keystore password" -AsSecureString

$keystorePwd = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($keystorePassword))
$keystorePwdConfirm = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($keystorePasswordConfirm))

if ($keystorePwd -ne $keystorePwdConfirm) {
    Write-Host "❌ Passwords do not match!"
    exit 1
}

$keyPassword = Read-Host "Enter key password" -AsSecureString
$keyPasswordConfirm = Read-Host "Confirm key password" -AsSecureString

$keyPwd = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($keyPassword))
$keyPwdConfirm = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($keyPasswordConfirm))

if ($keyPwd -ne $keyPwdConfirm) {
    Write-Host "❌ Passwords do not match!"
    exit 1
}

$keyName = Read-Host "Enter your name/organization"
$keyEmail = Read-Host "Enter your email"

# Generate keystore
Write-Host ""
Write-Host "🔑 Generating 4096-bit RSA keystore..."
Write-Host ""

$keystoreDir = "android\app"
$keystorePath = "$keystoreDir\release.keystore"

# Create directory if it doesn't exist
if (-not (Test-Path $keystoreDir)) {
    New-Item -ItemType Directory -Path $keystoreDir | Out-Null
}

# Run keytool
& keytool -genkey -v -keystore $keystorePath `
  -keyalg RSA -keysize 4096 -validity 36500 `
  -alias ssc_quiz_arena_key `
  -keypass "$keyPwd" `
  -storepass "$keystorePwd" `
  -dname "CN=$keyName, OU=Mobile, O=Organization, L=City, S=State, C=IN"

Write-Host ""
Write-Host "✅ Keystore generated successfully!"
Write-Host ""
Write-Host "📝 IMPORTANT: Save these values securely:"
Write-Host "   - Keystore Password: $keystorePwd"
Write-Host "   - Key Password: $keyPwd"
Write-Host "   - Key Alias: ssc_quiz_arena_key"
Write-Host ""
Write-Host "📦 Next Steps:"
Write-Host "   1. Copy 'android\app\release.keystore' to a secure location"
Write-Host "   2. Store passwords in your password manager"
Write-Host "   3. Add to GitHub Secrets (never commit to repo)"
Write-Host ""
Write-Host "🔐 To encode for GitHub Actions (PowerShell):"
Write-Host "   [Convert]::ToBase64String([IO.File]::ReadAllBytes('android\app\release.keystore')) | Out-File release.keystore.b64"
Write-Host ""
