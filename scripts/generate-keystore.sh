#!/bin/bash
# Android Signing Key Generation Script
# Run this ONCE and back up the keystore file securely!

set -e

echo "==================================="
echo "SSC Quiz Arena - Android Key Setup"
echo "==================================="
echo ""

# Check if keystore already exists
if [ -f "android/app/release.keystore" ]; then
    echo "❌ ERROR: release.keystore already exists!"
    echo "   Do not regenerate - this will break existing releases."
    echo "   If lost, restore from your backup."
    exit 1
fi

# Get inputs
read -p "Enter keystore password: " KEYSTORE_PASSWORD
read -p "Confirm keystore password: " KEYSTORE_PASSWORD_CONFIRM

if [ "$KEYSTORE_PASSWORD" != "$KEYSTORE_PASSWORD_CONFIRM" ]; then
    echo "❌ Passwords do not match!"
    exit 1
fi

read -p "Enter key password: " KEY_PASSWORD
read -p "Confirm key password: " KEY_PASSWORD_CONFIRM

if [ "$KEY_PASSWORD" != "$KEY_PASSWORD_CONFIRM" ]; then
    echo "❌ Passwords do not match!"
    exit 1
fi

read -p "Enter your name/organization: " KEY_NAME
read -p "Enter your email: " KEY_EMAIL

# Generate keystore
echo ""
echo "🔑 Generating 4096-bit RSA keystore..."
echo ""

keytool -genkey -v -keystore android/app/release.keystore \
  -keyalg RSA -keysize 4096 -validity 36500 \
  -alias ssc_quiz_arena_key \
  -keypass "$KEY_PASSWORD" \
  -storepass "$KEYSTORE_PASSWORD" \
  -dname "CN=$KEY_NAME, OU=Mobile, O=Organization, L=City, S=State, C=IN"

echo ""
echo "✅ Keystore generated successfully!"
echo ""
echo "📝 IMPORTANT: Save these values securely:"
echo "   - Keystore Password: $KEYSTORE_PASSWORD"
echo "   - Key Password: $KEY_PASSWORD"
echo "   - Key Alias: ssc_quiz_arena_key"
echo ""
echo "📦 Backup Instructions:"
echo "   1. Copy 'android/app/release.keystore' to a secure location"
echo "   2. Store passwords in your password manager"
echo "   3. Add to GitHub Secrets (never commit to repo)"
echo ""
echo "🔐 To encode for GitHub Actions:"
echo "   base64 -i android/app/release.keystore -o release.keystore.b64"
echo ""
