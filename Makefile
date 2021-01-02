INSTALL_PATH = /usr/local/bin/swift_string_obfuscator

build:
	swift package update
	swift build -c release

install: build
	cp -f .build/release/swift_string_obfuscator $(INSTALL_PATH)

clean:
	rm -rf .build

uninstall:
	rm -f $(INSTALL_PATH)

xcode:
	swift package generate-xcodeproj
	xed .