import PackageDescription

let package = Package(
    name: "DVB",
    dependencies: [
        .Package(url: "https://github.com/utahiosmac/Marshal", majorVersion: 1, minor: 2),
        .Package(url: "https://github.com/kiliankoe/gausskrueger", majorVersion: 0, minor: 2),
    ]
)
