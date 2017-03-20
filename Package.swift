import PackageDescription

let package = Package(
    name: "DVB",
	dependencies: [
		.Package(url: "https://github.com/utahiosmac/Marshal", majorVersion: 1, minor: 2)
	]
)
