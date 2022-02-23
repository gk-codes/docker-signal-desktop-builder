#!/bin/bash

echo "Retrieving latest Signal version..."
wget --quiet https://api.github.com/repos/signalapp/Signal-Desktop/releases -O releases.json
# Get the version from the tag_name and the download URL.
signalversion=$(jq . releases.json | grep tag_name | grep -v beta | head -n 1 | cut -d'"' -f4 | tr -d 'v')
echo ${signalversion} > signalversion.txt
echo "Latest Signal version: ${signalversion}"

echo "Retrieving Node.js version..."
curl -Ls -o nodejsversion.txt https://raw.githubusercontent.com/signalapp/Signal-Desktop/v${signalversion}/.nvmrc
nodejsversion=$(cat nodejsversion.txt)
echo "Latest Node.js version: ${nodejsversion}"

podman build --format docker \
    --build-arg NODE_VERSION=${nodejsversion} \
    --build-arg SIGNAL_VERSION=${signalversion} \
    -t build-signal-desktop .

exit 0