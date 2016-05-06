# DVB

[![CI Status](http://img.shields.io/travis/Kilian Koeltzsch/DVB.svg?style=flat)](https://travis-ci.org/kiliankoe/DVB)
[![Version](https://img.shields.io/cocoapods/v/DVB.svg?style=flat)](http://cocoapods.org/pods/DVB)
[![License](https://img.shields.io/cocoapods/l/DVB.svg?style=flat)](http://cocoapods.org/pods/DVB)
[![Platform](https://img.shields.io/cocoapods/p/DVB.svg?style=flat)](http://cocoapods.org/pods/DVB)

This is an unofficial Swift package, giving you a few options to query Dresden's public transport system for current bus- and tramstop data.

If you're looking for something like this for [Node.js](https://github.com/kiliankoe/dvbjs) or [Python](https://github.com/kiliankoe/dvbpy), just click 
the respective links :)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

DVB is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DVB"
```

DVB should also be compatible with Carthage out of the box :)

## Quick Start

Be sure to check the docs for more detailed information on how to use this library, but here are some quick examples for getting started right away.

### Monitor a single stop

Monitor a single stop to see every bus or tram leaving this stop. You can also optionally add parameters for a given time offset, filtering for a
specific line or limiting the amount of results.

```swift
DVB.monitor("Pirnaischer Platz") { (connections) in
    // do something with the list of connections
}
```

More is still to come ;)

## Author

Kilian Koeltzsch, [@kiliankoe](https://github.com/kiliankoe)

## License

DVB is available under the MIT license. See the LICENSE file for more info.
