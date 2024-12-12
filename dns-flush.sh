#!/bin/bash

flush_dns() {
    version=$(sw_vers -productVersion)
    if [[ $version == 11.* || \
          $version == 12.* || \
          $version == 13.* || \
          $version == 14.* || \
          $version == 15.* ]]; then
        sudo dscacheutil -flushcache
        sudo killall -HUP mDNSResponder
    elif [[ $version == 10.14.* || \
            $version == 10.15.* ]]; then
        sudo killall -HUP mDNSResponder
    elif [[ $version == 10.12.* || \
            $version == 10.13.* ]]; then
        sudo dscacheutil -flushcache
        sudo killall -HUP mDNSResponder
    elif [[ $version == 10.10.* || \
            $version == 10.11.* ]]; then
        sudo discoveryutil mdnsflushcache 2>/dev/null || true
    else
        echo "Unsupported macOS version: $version"
        exit 1
    fi
}

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
   exec sudo "$0" "$@"
   exit $?
fi

flush_dns
echo "DNS cache has been successfully flushed."
exit 0