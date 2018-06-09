SWIFTCMD=swift

test:
	# $(SWIFTCMD) test --parallel
	xcodebuild test -scheme DVB-Package | xcpretty

docs:
	jazzy --xcodebuild-arguments -target,DVB --theme fullwidth

.PHONY: test, docs
