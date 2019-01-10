# FTC App without Android Studio
  This fork of `ftc_app` aims to provide installation scripts for Linux more up-to-date dependencies for the Android app.

## Supported Systems:
  - Fedora 29 (tested)
  - Ubuntu 18 (untested)

## Why?
  I don't like Android Studio.

  I personally think VS Code is the best IDE, but regardless you should be able to use whatever you want.

## What's New
  - `installer.sh` - This is a pretty basic shell script that will check/perform the following things:
    - Check for `java` and `javac` 1.8 on the system. If not found, the script will install `openjdk` (Ubuntu and Fedora support)
    - Check for the Android SDK Manager in `~/Android` (this is the default location for Android Studio as well). If not present, the installer will download the sdk-tools standalone command line tool and unzip it into `~/Android`
    - Use the SDK Manager to install `platform-tools`, and build tools for `android-28`
    - Then, if the `local.properties` file has not been set for gradle, the file will be created and `sdk.dir` will be set to `~/Android`

  - `Makefile` - Simple `make` commands for building and installing the app on your phone. This could easily be translate into VS Code build tasks. Available commands:
    - `all` - runs `build`
    - `build` - executes the default `gradlew build` command
    - `install` - uses ADB to install FTC Robot Controller (built from `TeamCode`) on your phone
    - `installDriverStation` - same as `install`, but the provided Driver Station apk
    - `clean` - executes the default `gradlew clean` command

  - Build Updates: 
    - Gradle build files updated to target Android 28
    - Minimum SDK is Android 23 to support older phones
    - Gradle version updated to `5.1` from `4.4`
    - Android gradle plugin updated to `3.2.1` from `3.1.3`
    - Build scripts fixed to remove (most) gradle warnings
    - A few lint warnings fixed in example code

## Notes
  - This is a side project, and is by no means tested rigorously. Use at your own risk.
  - Feel free to fork and pull request to make improvements!
  - Same goes for issues!
  - If someone wants to test `installer.sh` on Ubuntu, that would be great
