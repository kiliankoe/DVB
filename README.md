# 🚆DVB

[![Travis](https://img.shields.io/travis/kiliankoe/DVB.svg?style=flat-square)](https://travis-ci.org/kiliankoe/DVB)
[![Version](https://img.shields.io/cocoapods/v/DVB.svg?style=flat-square)](http://cocoapods.org/pods/DVB)
[![License](https://img.shields.io/cocoapods/l/DVB.svg?style=flat-square)](http://cocoapods.org/pods/DVB)
[![Platform](https://img.shields.io/cocoapods/p/DVB.svg?style=flat-square)](http://cocoapods.org/pods/DVB)
[![Docs](https://img.shields.io/cocoapods/metrics/doc-percent/DVB.svg?style=flat-square)](http://cocoadocs.org/docsets/DVB)
[![Codecov](https://img.shields.io/codecov/c/github/kiliankoe/DVB.svg?style=flat-square)](https://codecov.io/gh/kiliankoe/DVB)

This is an unofficial Swift package giving you a few options to query Dresden's public transport system for current bus- and tramstop data.

Want something like this for another language, look [no further](https://github.com/kiliankoe/vvo#libraries) 🙂

## Example

Have a look at the [example iOS app](https://github.com/kiliankoe/DVBExample).

## Installation

DVB is available through Cocoapods, Carthage/Punic and Swift Package Manager, take your pick.

```swift
// Cocoapods
pod 'DVB'

// Carthage
github "kiliankoe/DVB"

// Swift Package Manager
.Package(url: "https://github.com/kiliankoe/DVB", majorVersion: 2)
```


## Quick Start

Be sure to check the [docs](http://cocoadocs.org/docsets/DVB) for more detailed information on how to use this library, but here are some quick examples for getting started right away.

***Caveat***: Stops are always represented by their ID. You can get a stop's ID via `Stop.find()`. Some of the methods listed below offer convenience overloads, which are listed here since they look nicer. The downside to these is that they have to send of a find request for every stop first resulting in a significant overhead. Should you already have a stop's ID at hand I **strongly** suggest you use that instead.

### Monitor a single stop

Monitor a single stop to see every bus, tram or whatever leaving this stop. The necessary stop id can be found by using the `find()` function.

```swift
// See caveat above
Departure.monitor(stopWithName: "Postplatz") { result in
	guard let response = result.success else { return }
	print(response.departures)
}
```

### Find a specific stop

Say you're looking for "Helmholtzstraße". You can use the following to find a list of matches.

```swift
Stop.find("Helmholtzstraße") { result in
	guard let response = result.success else { return }
	print(response.stops)
}
```

### Find a route from A to B

Want to go somewhere?

```swift
// See caveat above
Trip.find(from: "Albertplatz", to: "Hauptbahnhof") { result in
	guard let response = result.success else { return }
	print(response.routes)
}
```

### Look up current route changes

Want to see if your favorite lines are currently being re-routed due to construction or some other reason? Check the published list of route changes.

```swift
RouteChange.get { result in
	guard let response = result.success else { return }
	print(response.lines)
	print(response.changes)
}
```

### Lines running at a specific stop

Looking to find which lines service a specific stop? There's a func for that.

```swift
// See caveat above
Line.get(forStopName: "Postplatz") { result in 
	guard let response = result.success else { return }
	print(response.lines)
}
```

## Authors

Kilian Koeltzsch, [@kiliankoe](https://github.com/kiliankoe)

Max Kattner, [@maxkattner](https://github.com/maxkattner)

## License

DVB is available under the MIT license. See the LICENSE file for more info.

## Terms of Service

Please refer to the [VVO Terms of Service](https://www.vvo-online.de/de/service/widgets/nutzungsbedingungen-1671.cshtml) regarding their widget. Take particular care not to use this library to send off to many requests to their graciously-provided API.
