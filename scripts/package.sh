#!/bin/bash

# Reddit Translation Disabler - Packaging Script
# Creates a zip file with all extension files, excluding blacklisted items

# Configuration
EXTENSION_NAME="reddit-translation-disabler"
VERSION=$(grep '"version"' manifest.json | sed 's/.*"version": "\([^"]*\)".*/\1/')
OUTPUT_DIR="dist"
ZIP_NAME="${EXTENSION_NAME}-v${VERSION}.zip"
TEMP_DIR="temp_package"

# Blacklisted files and directories
BLACKLIST=(
    "scripts"
    "*.kra"
    "dist"
    ".git"
    ".gitignore"
    "*.zip"
    "*.tar.gz"
    "temp_package"
)

echo "🔧 Packaging Reddit Translation Disabler Extension"
echo "📦 Version: $VERSION"
echo "🗂️  Output: $OUTPUT_DIR/$ZIP_NAME"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Remove existing zip if it exists
if [ -f "$OUTPUT_DIR/$ZIP_NAME" ]; then
    echo "🗑️  Removing existing package..."
    rm "$OUTPUT_DIR/$ZIP_NAME"
fi

# Create temporary directory and copy files
echo "📁 Preparing files..."
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

# Copy all files except blacklisted ones
echo "🚫 Excluding: ${BLACKLIST[*]}"

# Use find to copy files while excluding blacklisted items
find . -type f -not -path "./.git/*" -not -path "./scripts/*" -not -path "./dist/*" -not -path "./temp_package/*" -not -name "*.kra" -not -name "*.zip" -not -name "*.tar.gz" -not -name ".gitignore" | while read file; do
    # Create directory structure in temp dir
    dir=$(dirname "$file")
    mkdir -p "$TEMP_DIR/$dir"
    cp "$file" "$TEMP_DIR/$file"
done

# Create the zip file from temp directory
echo "📦 Creating ZIP package..."
cd "$TEMP_DIR"
zip -r "../$OUTPUT_DIR/$ZIP_NAME" .
cd ..

# Clean up temp directory
rm -rf "$TEMP_DIR"

# Check if zip was created successfully
if [ $? -eq 0 ]; then
    echo "✅ Package created successfully!"
    echo "📁 Location: $OUTPUT_DIR/$ZIP_NAME"
    echo "📊 Size: $(du -h "$OUTPUT_DIR/$ZIP_NAME" | cut -f1)"
    
    # List contents of the zip for verification
    echo ""
    echo "📋 Package contents:"
    unzip -l "$OUTPUT_DIR/$ZIP_NAME"
else
    echo "❌ Failed to create package!"
    exit 1
fi

echo ""
echo "🎉 Extension is ready for distribution!"
echo "💡 To install: Load $OUTPUT_DIR/$ZIP_NAME in Firefox developer mode"
