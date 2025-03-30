#!/bin/bash

sed -i 's/user www-data;/user root;/g' /etc/nginx/nginx.conf

# Check if environment variables are set
if [[ -z "$WEBDAV_USER" || -z "$WEBDAV_PASSWORD" ]]; then
    echo "Error: WEBDAV_USER and WEBDAV_PASSWORD must be set." >&2
    exit 1
fi

# Check if `mkpasswd` is installed
if ! command -v mkpasswd >/dev/null; then
    echo "Error: Install 'mkpasswd' (e.g., 'apt install whois')." >&2
    exit 1
fi

# Generate bcrypt hash (cost factor 12, adjust as needed)
hashed_password=$(mkpasswd -m bcrypt -s -R 12 <<< "$WEBDAV_PASSWORD")

# Append credentials to file
echo "$WEBDAV_USER:$hashed_password" | tee -a /etc/nginx/webdav.passwd >/dev/null

echo "Credentials added successfully."

exec "$@"