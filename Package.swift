import PackageDescription

let package = Package(
    name: "DVB",
    dependencies: [
      .Package(url: "https://github.com/Quick/Quick", majorVersion: 0, minor: 10),
      .Package(url: "https://github.com/kiliankoe/Kanna", majorVersion: 2, minor: 1),
      .Package(url: "https://github.com/sharplet/Regex", majorVersion: 0, minor: 4),
    ]
)
