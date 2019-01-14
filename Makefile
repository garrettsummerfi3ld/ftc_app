.PHONY: all build install clean

all: build

build:
	./gradlew build

install:
	./gradlew installDebug

installDriverStation:
	${HOME}/Android/Sdk/platform-tools/adb install doc/apk/FtcDriverStation-release.apk

clean:
	./gradlew clean
