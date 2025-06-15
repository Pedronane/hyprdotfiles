#!/bin/bash

# Reload the systemd user unit daemon
systemctl --user daemon-reload

# Enable and start the user service
systemctl --user enable opentabletdriver --now
