# FTC App [![Build Status](https://travis-ci.org/garrettsummerfi3ld/ftc_app_installer.svg?branch=master)](https://travis-ci.org/garrettsummerfi3ld/ftc_app_installer)

This fork of `ftc_app` aims to provide installation scripts for Linux and more up-to-date dependencies for the Android app.

## Supported Systems

    - Fedora 29 (tested)
    - Ubuntu 16.04 + (tested)

## Why

Tools to do whatever your needs seem fit is the best way to get all set up is sometimes a pain. That one dependency could be missing or if you're running a full setup of a teams programming division, this is a pain to go and download everything and anything.

This is going to fix all the issues with setting up a default environment for FTC Games.

## What's New

`installer.sh` - This is a pretty basic shell script that will check/perform the following things:

- Check for local `git` installation
- Check for a local downloaded repo, and if not located you have the option of downloading the master repo from GitHub
- Check for `java` and `javac` 1.8 on the system. If not found, the script will install `openjdk` (Ubuntu and Fedora support)
- Check for the Android SDK Manager in `~/Android/Sdk` (this is the default location for Android Studio as well). If not present, the installer will download the sdk-tools standalone command line tool and unzip it into `~/Android/Sdk`
- Use the SDK Manager to install `platform-tools`, and build tools for `android-28`
- Then, if the `local.properties` file has not been set for gradle, the file will be created and `sdk.dir` will be set to `~/Android/Sdk`

- `Makefile` - Simple `make` commands for building and installing the app on your phone. This could easily be translate into VS Code build tasks. Available commands:

  - `all` - runs `build`
  - `build` - executes the default `gradlew build` command
  - `install` - executes the default `gradlew installDebug` command
  - `installDriverStation` - uses ADB (default location) to install the provided driver station APK
  - `clean` - executes the default `gradlew clean` command

- Build Updates:
  - Gradle build files updated to target Android 28
  - Minimum SDK is Android 23 to support older phones
  - Gradle version updated to `5.1` from `4.4`
  - Android gradle plugin updated to `3.2.1` from `3.1.3`
  - Build scripts fixed to remove (most) gradle warnings
  - A few lint warnings fixed in example code

## TODO

- Adding support for downloading and installing IDEs from the script if user requests
- Support for more package systems and operating systems (Debian, Mint, Arch, and others)
- Adding support for downloading tools such as GitKraken if user requests
- Support for Windows and macOS

## Notes

- This is a side project, and is by no means tested rigorously. **Use at your own risk.**
- Feel free to fork and pull request to make improvements!
- Same goes for issues!
