#!/bin/bash

echo "run.sh"

SIGNAL_BIN=${HOME}/Tools/Signal.AppImage
SIGNAL_VER=$(cat signalversion.txt)
CONTAINER_NAME=build-signal-desktop

echo "Starting container ${CONTAINER_NAME}"
CONTAINER_ID=$(podman run --name ${CONTAINER_NAME} -p 8080:8080 -d localhost/build-signal-desktop:latest)

echo "Downloading Signal v${SIGNAL_VER}"
curl http://localhost:8080/Signal-${SIGNAL_VER}.AppImage --output ${SIGNAL_BIN}
chmod +x ${SIGNAL_BIN}

echo "Stopping container..."
podman stop ${CONTAINER_ID}
podman container rm ${CONTAINER_ID}