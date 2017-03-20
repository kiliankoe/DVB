# Changelog

## [Unreleased]

### Added

- Trip Requests 🛤

### Fixed

- `Depature.platform` is optional, as it should be

### Changed

- now dependent on Marshal, Carthage users will have to pull this in as well

## [2.1.0] - 2017-02-27

### Added

- Route change lookups
- Serviced lines lookup
- convenience `Departure.monitor(stopWithName:)`

### Fixed

- Coordinates are back :clap:

### Changed

- Some argument labels were made more explicit

### Removed

- `Stop.findNear()` since the previous implementation was broken. Will hopefully find its way back soon.

## [2.0.0] - 2017-02-19

### Added

- Compatibility with SPM.

### Changed

- Migrated to use WebAPI instead of old Widgets endpoint.
- Basic API, no more `DVB` class to interact with.

### Removed

- Example app from repo. That will live somewhere else.
- Local stop list, since there's now a good endpoint for this.
- Monitor filters, please implement this yourself if you need this functionality.

### Broke

- Everything regarding coordinates, will fix soon (hopefully)!



## [1.1.0] - 2016-10-03

## [1.0.0] - 2016-09-28

### Added

- Support for Swift 3 ✨



## [0.7.1] - 2016-05-25

### Added

- `nearestStops()` finds nearest stops 🎉



## [0.7.0] - 2016-05-22

## [0.6.1] - 2016-05-22

## [0.6.0] - 2016-05-22

### Changed

- `DVB.find` now uses a local list of all stops, since this adds coordinate data \o/



## [0.5.0] - 2016-05-09

### Added

- `DVB.find` can now be used to find specific stops using a portion of their title.



## [0.4.0] - 2016-05-09

## [0.3.0] - 2016-05-07

## [0.2.0] - 2016-05-07

