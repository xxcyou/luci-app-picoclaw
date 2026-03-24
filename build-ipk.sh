#!/bin/bash

set -e

# Build script for luci-app-picoclaw IPK package
# Compatible with OpenWrt traditional LuCI

PACKAGE_NAME="luci-app-picoclaw"
VERSION="1.0.0-20260324"
ARCH="all"
MAINTAINER="LIKE2000-ART"
DESCRIPTION="LuCI Support for PicoClaw AI Assistant (Lua Compatible)"

# Create build directory
BUILD_DIR="build"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Copy package files to build directory
cp -r luci-app-picoclaw "$BUILD_DIR/"

# Remove build artifacts and source files we don't need in IPK
rm -rf "$BUILD_DIR/luci-app-picoclaw/.git"
rm -rf "$BUILD_DIR/luci-app-picoclaw/.github"
rm -f "$BUILD_DIR/luci-app-picoclaw/.gitignore"
rm -f "$BUILD_DIR/luci-app-picoclaw/README.md"
rm -f "$BUILD_DIR/luci-app-picoclaw/LICENSE"
rm -rf "$BUILD_DIR/luci-app-picoclaw/scripts"
# Keep root and usr directories which contain the actual package files

# Create IPK structure
IPK_DIR="$BUILD_DIR/ipk"
mkdir -p "$IPK_DIR/control"
mkdir -p "$IPK_DIR/data"

# Create control file
cat > "$IPK_DIR/control/control" << EOF
Package: $PACKAGE_NAME
Version: $VERSION
Architecture: $ARCH
Maintainer: $MAINTAINER
Description: $DESCRIPTION
Source: $PACKAGE_NAME
Section: luci
Priority: optional
Depends: picoclaw
EOF

# Copy package files to data directory
cp -r "$BUILD_DIR/luci-app-picoclaw/root" "$IPK_DIR/data/" 2>/dev/null || true
cp -r "$BUILD_DIR/luci-app-picoclaw/usr" "$IPK_DIR/data/"

# Create control.tar.gz
cd "$IPK_DIR/control"
tar --format=gnu -czf "../control.tar.gz" .

# Create data.tar.gz
cd "$IPK_DIR/data"
tar --format=gnu -czf "../data.tar.gz" .

# Create debian-binary
echo "2.0" > "$IPK_DIR/debian-binary"

# Create final IPK
cd "$IPK_DIR"
ar r "$PACKAGE_NAME"_"$VERSION"_"$ARCH".ipk debian-binary control.tar.gz data.tar.gz

# Move to root directory
mv "$PACKAGE_NAME"_"$VERSION"_"$ARCH".ipk ../..

echo "✅ IPK package built successfully!"
echo "Package: $PACKAGE_NAME"_"$VERSION"_"$ARCH".ipk"