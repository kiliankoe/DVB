import PackageDescription

let package = Package(
  name: "DVB-Example",
  dependencies: [
    .Package(url: "../", majorVersion: 1)
  ]
)
