SWIFTCMD=swift

test:
	$(SWIFTCMD) test --parallel

docs:
	jazzy --xcodebuild-arguments -target,DVB --theme fullwidth

.PHONY: test, docs
