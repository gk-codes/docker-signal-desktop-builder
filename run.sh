#!/bin/bash

echo "run.sh"

# cannot overwrite Signal.AppImage when Signal is running
if pgrep "signal-desktop" > /dev/null 
then
    echo "Signal Desktop is running."
    echo "Close Signal and try again."
    exit 1
fi

TARGET_DIR=${HOME}/Tools
SIGNAL_BIN=${TARGET_DIR}/Signal.AppImage
SIGNAL_VER=$(cat signalversion.txt)
CONTAINER_NAME="build-signal-desktop"
SIGNAL_URL=http://localhost:8080/Signal-${SIGNAL_VER}.AppImage

# check for signalversion.txt
if [ ! -f signalversion.txt ]; then
    echo "Cannot find signalversion.txt, aborting"
    exit 1
fi

# create target directory if it does not exist
if [ ! -d "${TARGET_DIR}" ]; then
    mkdir -p "${TARGET_DIR}"
fi

echo "Starting container ${CONTAINER_NAME}"
CONTAINER_ID=$(podman run --name ${CONTAINER_NAME} -p 8080:8080 -d localhost/build-signal-desktop:latest)

echo "Downloading Signal v${SIGNAL_VER}"
wget -c "${SIGNAL_URL}" -O "${SIGNAL_BIN}"
chmod +x ${SIGNAL_BIN}

echo "Stopping container..."
podman stop ${CONTAINER_ID}
podman container rm ${CONTAINER_ID}

echo "Done"