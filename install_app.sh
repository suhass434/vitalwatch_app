#!/bin/bash

# Define installation paths
APP_NAME="vitalwatch"
INSTALL_DIR="/opt/$APP_NAME"
DESKTOP_FILE_PATH="$HOME/.local/share/applications/$APP_NAME.desktop"
EXECUTABLE="run"
ICON_FILE="icon.png"

# Function to handle errors
handle_error() {
    echo "Installation failed!"
    exit 1
}

# Create the installation directory
echo "Creating installation directory at $INSTALL_DIR..."
sudo mkdir -p "$INSTALL_DIR" || handle_error

# Copy executable to the installation directory
echo "Copying executable to $INSTALL_DIR..."
sudo cp "$EXECUTABLE" "$INSTALL_DIR/" || handle_error

# Make the executable runnable
sudo chmod +x "$INSTALL_DIR/$EXECUTABLE" || handle_error

# Copy icon if available
if [ -f "$ICON_FILE" ]; then
    echo "Copying icon..."
    sudo cp "$ICON_FILE" "$INSTALL_DIR/" || handle_error
fi

# Create a .desktop file
echo "Creating desktop entry..."
cat <<EOF | tee "$DESKTOP_FILE_PATH" >/dev/null
[Desktop Entry]
Version=1.0
Type=Application
Name=$APP_NAME
Exec=$INSTALL_DIR/$EXECUTABLE
Icon=$INSTALL_DIR/$ICON_FILE
Terminal=false
Categories=Utility;
Comment=Keep your system healthy and under watch.
EOF

# Make the .desktop file executable
chmod +x "$DESKTOP_FILE_PATH" || handle_error

# Validate the desktop file
echo "Validating .desktop file..."
desktop-file-validate "$DESKTOP_FILE_PATH"
if [ $? -ne 0 ]; then
    handle_error
fi

# Register only the new desktop file
echo "Updating application database for $APP_NAME..."
desktop-file-install --dir="$HOME/.local/share/applications" "$DESKTOP_FILE_PATH" || handle_error

# If everything worked, print success message
echo "Installation complete! You can now find '$APP_NAME' in your application menu."
