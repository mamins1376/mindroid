# Minimal Android Project Template

Creates an empty activity. Needs Java 8 installed, along with one Android SDK platform version.

## Building

Make sure `$ANDROID_HOME` points to SDK installation.

1. Adjust project name along with build-tools, cmdline-tools and platform version in `Makefile`.
1. `$ make` will create the apk file in project root
1. `$ make install` will also install that on the device attached to adb.