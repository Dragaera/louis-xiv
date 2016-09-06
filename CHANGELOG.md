# Change log

This document represents a high-level overview of changes made to this project.
It will not list every miniscule change, but will allow you to view - at a
glance - what to expact from upgrading to a new version.

## [unpublished]

### Added

### Changed

- Run container as non-privileged user

### Fixed

- Fix signal forwarding by using `exec` within docker entrypoint, ensuring the
- spawned process is a direct child of tini.

### Security

### Deprecated

### Removed


## [0.1.0] - 2016-09-05

### Added

- Management of [SolarLog](http://www.solar-log.com) stations.
  - Automated update of SolarLog station data.
- Management of [IFTTT](http://ifttt.com) Maker keys & events.
- Basic conditions, allowing to execute actions based on data of a SolarLog
  station.
