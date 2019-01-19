#!/usr/bin/env bash
# TODO:
#  - Java install
#  - Gradle is handled by wrapper
#  - SDK Installer manual download
#  - Possibly install build tools, Gradle only warns about it
#  - Support for Ubuntu (duh) and Fedora (because me)
#  - OSX and Windows... I don't even know... Not in this file at least
#
# Format:
#  - Guided install - stretch goal
#  - Start with options and install all

FORCE_YES=0

function helpMessage() {
  echo "Usage: y - force yes on installations"
}

#VARIABLES
local HOST_INFO=$(hostnamectl | grep "Operating System:" 2>&1)

function yesNo() {
  # yes if force yes is on
  if [[ $FORCE_YES == 1 ]]; then
    return 0
  fi

  # Use return status for answer
  read answer
  case $answer in
    "y"* | "Y"*)
      return 0
      ;;
    "n"* | "N"*)
      return 1
      ;;
    *)
      return 2
      ;;
  esac
}


# 0 on success
# 1 on no java
# 2 on bad java version
# 3 on no javac
# 4 on bad javac version
function checkJava() {
  # Check command not found
  java -version &> /dev/null
  if [[ ${?} == 127 ]]; then
    return 1
  fi

  # Java must be 1.8
  local JAVA_VERSION=$(java -version 2>&1)
  if [[ $JAVA_VERSION != *"1.8."* ]]; then
    return 2
  fi

  javac -version &> /dev/null
  if [[ ${?} == 127 ]]; then
    return 3
  fi

  local JAVAC_VERSION=$(javac -version 2>&1)
  if [[ $JAVAC_VERSION != *"1.8."* ]]; then
    return 4
  fi

  return 0
}

function installJava() {
  local HOST_INFO=$(hostnamectl | grep "Operating System:" 2>&1)
  if [[ $HOST_INFO == *"Ubuntu"* ]]; then
      sudo apt-get install openjdk-8-jre openjdk-8-jdk
  elif [[ $HOST_INFO == *"Fedora"* ]]; then
    sudo yum install java-1.8.0-openjdk java-1.8.0-openjdk-devel
  fi
}

# Chcck git installation
function checkGit() {
  local GIT_VERSION=$(git --version)
  if [[ $GIT_VERSION != *"git version"* ]]; then
    return 1
  fi
  
  return 0
}

# Install git depending on distro (WIP)
function installGit() {
  if [[ $HOST_INFO == *"Ubuntu"* ]]; then
    sudo apt install git
  elif [[ $HOST_INFO == *"Fedora"* ]]; then
    sudo yum install git
  fi
}

# Clones the repo from a link
function gitRepoDownload() {
  read -p "Git repo for download (no input clones the official FTC repo): " repoLink
  if [ -z "$repoLink"]; then
    mkdir ~/AndroidProjects && cd ~/AndroidProjects
    git clone https://github.com/ftctechnh/ftc_app.git
  else
    mkdir ~/AndroidProjects && cd ~/AndroidProjects
    git clone $repoLink
  fi
}

SDK_HOME=${HOME}/Android/Sdk

# 1: binary not found in the ~/Android/Sdk folder
function checkAndroidSDK() {
  # Check if sdkmanager exists
  ${SDK_HOME}/tools/bin/sdkmanager --version &> /dev/null
  if [[ ${?} == 127 ]]; then
    return 1
  fi

  return 0
}

function downloadAndroidSDK() {
  local SDK_ZIP="sdk-tools-linux-4333796.zip"
  # Download the zip file
  wget "https://dl.google.com/android/repository/"${SDK_ZIP}

  # Check for ~/Android and ~/Android/Sdk
  ls ${SDK_HOME} &> /dev/null
  if [[ ${?} -gt 0 ]]; then
    mkdir -p ${SDK_HOME}
  fi

  unzip ${SDK_ZIP} -d ${SDK_HOME}
  
  # Check for repositories.cfg
  ls ${SDK_HOME}/repositories.cfg &> /dev/null
  if [[ ${?} -ne 0 ]]; then
    touch ${SDK_HOME}/repositories.cfg
  fi
}

# Note: if the package is installed, the manager will not download it
function downloadAndroidPackages() {
  local SDK_MANAGER=${SDK_HOME}/tools/bin/sdkmanager
  local PACKAGE_LIST="platform-tools platforms;android-28 build-tools;28.0.3 sources;android-28"

  ${SDK_MANAGER} ${PACKAGE_LIST}
}

function setLocalProperties() {
  # Check if local.properties already exists
  ls local.properties &> /dev/null
  if [[ ${?} -ne 0 ]]; then
    touch local.properties
  else
    return 0
  fi

  echo "sdk.dir=${SDK_HOME}" >> local.properties
}

# BEGIN SCRIPT

# DISTRO CHECK
echo "Checking installed distro..."
echo $(tput setaf 1) $HOST_INFO $(tput sgr 0)

# ROOT CHECK
if [[ ${EUID} == 0 ]]; then
  echo "WARNING: Installer is not designed to run as root, continue at your own risk, ctrl-C to exit (recommended)"
  read
fi
# GIT CHECK
echo "Checking git..."
checkGit
if [[ ${?} -ne 0]]; then
  printf "Git is not installed, install git? [y/n]"
  if yesNo; then
    installGit
  else
    echo "Skipping git installation"
  fi
else
  echo "Git installed"
fi

# CHECK ARGS
if [[ $1 == "-h" ]]; then
  echo $(helpMessage)
  exit 0
elif [[ $1 == "y" ]]; then
  FORCE_YES=1
fi

# JAVA CHECK
echo "Checking Java version..."
checkJava
if [[ ${?} -ne 0 ]]; then
  printf "JDK 1.8 not installed, install openJDK? [y/n]:"
  if yesNo; then
    installJava
  else
    echo "Skipping Java installation"
  fi
else
  echo "Java installed"
fi

# SDK CHECK
echo "Checking for the Android SDK in the ${SDK_HOME} folder..."
checkAndroidSDK
if [[ ${?} -ne 0 ]]; then
  echo "Downloading the Android SDK and placing it in ${SDK_HOME}"
  printf "Note: By continuing you agree to the Google terms and conditions [y/n]:"
  if yesNo; then
    downloadAndroidSDK
  else
    echo "Android SDK installation cancelled, now exiting"
    exit 1
  fi
else
  echo "Android SDK found"
fi

# INSTALL PACKAGES AND CLEANUP
printf "Would you like to download/check for necessary Android packages for ftc_app? [y/n]:"
if yesNo; then
  echo "Now checking/downloading necessary Android packages for ftc_app..."
  downloadAndroidPackages
else
  echo "Skipping SDK check"
fi

printf "Would you like the installer to setup local.properties for gradle (recommended)? [y/n]:"
if yesNo; then
  echo "Setting up local.properties..."
  setLocalProperties
else
  echo "Skipping local.properties setup..."
fi

printf "Would you like the installer to clone a specified repo? [y/n]"
if yesNo;
  echo "Cloning the repository..."
  gitRepoDownload
else
  echo "Skipping cloning setup repo"
fi

echo "Installer finished, exiting successfully"
