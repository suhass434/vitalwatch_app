#!/bin/bash

# Define installation paths
APP_NAME="VitalWatch"
INSTALL_DIR="$HOME/Applications/$APP_NAME"
EXECUTABLE="run"
ICON_FILE="icon.png"
PLIST_FILE="$HOME/Library/LaunchAgents/com.$APP_NAME.plist"

# Function to handle errors
handle_error() {
    echo "Installation failed!"
    exit 1
}

# Create the installation directory
echo "Creating installation directory at $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR" || handle_error

# Copy executable to the installation directory
echo "Copying executable to $INSTALL_DIR..."
cp "$EXECUTABLE" "$INSTALL_DIR/" || handle_error
chmod +x "$INSTALL_DIR/$EXECUTABLE" || handle_error

# Copy icon if available
if [ -f "$ICON_FILE" ]; then
    echo "Copying icon..."
    cp "$ICON_FILE" "$INSTALL_DIR/" || handle_error
fi

# Create a macOS application launcher (`.app` equivalent)
echo "Creating a launch script..."
LAUNCH_SCRIPT="$INSTALL_DIR/VitalWatch.command"
cat <<EOF > "$LAUNCH_SCRIPT"
#!/bin/bash
cd "$INSTALL_DIR"
./$EXECUTABLE
EOF

chmod +x "$LAUNCH_SCRIPT"

# Create a LaunchAgent plist for auto-start
echo "Creating LaunchAgent plist..."
cat <<EOF > "$PLIST_FILE"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>Label</key>
        <string>com.$APP_NAME</string>
        <key>ProgramArguments</key>
        <array>
            <string>$INSTALL_DIR/$EXECUTABLE</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
    </dict>
</plist>
EOF

# Load the LaunchAgent
launchctl load -w "$PLIST_FILE"

echo "Installation complete! You can now run '$APP_NAME' from $INSTALL_DIR or by opening VitalWatch.command"
