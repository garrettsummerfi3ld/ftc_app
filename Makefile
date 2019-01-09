.PHONY: all build install clean

all: build

build:
	./gradlew build

install: build TeamCode/build/outputs/apk/debug/TeamCode-debug.apk
	${HOME}/.android/platform-tools/adb install TeamCode/build/outputs/apk/debug/TeamCode-debug.apk

clean:
	./gradlew clean
