# 🚆DVB

[![CI Status](http://img.shields.io/travis/kiliankoe/DVB.svg?style=flat-square)](https://travis-ci.org/kiliankoe/DVB)
[![Version](https://img.shields.io/cocoapods/v/DVB.svg?style=flat-square)](http://cocoapods.org/pods/DVB)
[![License](https://img.shields.io/cocoapods/l/DVB.svg?style=flat-square)](http://cocoapods.org/pods/DVB)
[![Platform](https://img.shields.io/cocoapods/p/DVB.svg?style=flat-square)](http://cocoapods.org/pods/DVB)

This is an unofficial Swift package, giving you a few options to query Dresden's public transport system for current bus- and tramstop data.

If you're looking for something like this for [Node](https://github.com/kiliankoe/dvbjs), [Python](https://github.com/kiliankoe/dvbpy), [Ruby](https://github.com/kiliankoe/dvbrs) or [Go](https://github.com/kiliankoe/dvbgo), just click the respective links 🙂

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Caveat

This library will try to access data provided by HTTP-only endpoints. Doing so will require you to add certain App Transport Security Exceptions to your app's Info.plist.
These include the following:

- widgets.vvo-online.de
- efa.vvo-online.de

A correct Info.plist will have to include the following XML, unless of course you've already got `NSAllowArbitraryLoads` in there...

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>vvo-online.de</key>
        <dict>
            <!--Include to allow subdomains-->
            <key>NSIncludesSubdomains</key>
            <true/>
            <!--Include to allow HTTP requests-->
            <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
            <true/>
        </dict>
    </dict>
</dict>
```

## Installation

DVB is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```
pod "DVB"
```

Or via Carthage, whatever you prefer. Just add the following to your Cartfile:

```
github "kiliankoe/DVB"
```

## Quick Start

Be sure to check the [docs](http://cocoadocs.org/docsets/DVB) for more detailed information on how to use this library, but here are some quick examples for getting started right away.

### Monitor a single stop

Monitor a single stop to see every bus or tram leaving this stop. You can also optionally add parameters for a given time offset, filtering for a specific line, providing a list of allowed transport modes (see [TransportMode](https://github.com/kiliankoe/DVB/blob/master/DVB/Classes/DataTypes/TransportMode.swift)) or limiting the amount of results.

```swift
DVB.monitor("Pirnaischer Platz") { (departures) in
    // do something with the list of departures
}
```

### Find a specific stop

Say you're looking for "Zellescher Weg". You can use the following to find a selection of stops.

```swift
let stops = DVB.find("Zellesch")
// Directly returns a list of `Stop` values
```

You can also search for stops and their distance to a given location and optionally limit the results to a given radius.

```swift
let stops = DVB.nearestStops(latitude: 51.0271761, longitude: 13.7258114, radius: 300)
// Searches around the coordinate with a radius of 300 meters
// Returns a list of (Stop, Double) with the stop's distance to the loation
```

### List current route changes

The DVB publishes current route changes in the entire city. Look them up like this.

```swift
DVB.routeChanges { (updated, routeChanges) in
    // do something with the date last updated and list of route changes
}
```

More is still to come 😉

## Authors

Kilian Koeltzsch, [@kiliankoe](https://github.com/kiliankoe)

Max Kattner, [@maxkattner](https://github.com/maxkattner)

## License

DVB is available under the MIT license. See the LICENSE file for more info.

## Terms of Service

Please refer to the [VVO Terms of Service](https://www.vvo-online.de/de/service/widgets/nutzungsbedingungen-1671.cshtml) regarding their widget. Take particular care not to use this library to send off to many requests to their graciously-provided API.
