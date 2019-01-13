.PHONY: all build install clean

all: build

build:
	./gradlew build

install:
	./gradlew installDebug

installDriverStation:
	${HOME}/Android/platform-tools/adb install doc/apk/FtcDriverStation-release.apk

clean:
	./gradlew clean
