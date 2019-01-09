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

# 0 on success
# 1 on no java
# 2 on bad java version
# 3 on no javac
# 4 on bad javac version
function checkJava() {
  # Check command not found
  $(java -version 2> /dev/null)
  if [[ ${?} == 127 ]]; then
    return 1
  fi

  # Java must be 1.8
  local JAVA_VERSION=$(java -version)
  if [[ JAVA_VERSION != *"1.8."* ]]; then
    return 2
  fi

  $(javac -version 2> /dev/null)
  if [[ ${?} == 127 ]]; then
    return 3
  fi

  local JAVAC_VERSION=$(javac -version)
  if [[ JAVAC_VERSION != *"1.8."* ]]; then
    return 4
  fi

  return 0
}

function installJava() {
  yum install 
}

if [[ $EUID -ne 0 ]]; then
  echo "The installer should be ran as root"
  exit 1
fi

echo "Checking Java version..."
if checkJava; then
  echo "JDK 1.8 not installed, proceeding with OpenJDK installation"
  installJava
else
  echo "Java installed"
fi
