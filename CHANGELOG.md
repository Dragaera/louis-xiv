# Change log

This document represents a high-level overview of changes made to this project.
It will not list every miniscule change, but will allow you to view - at a
glance - what to expect from upgrading to a new version.

## [unpublished]

### Added

- Basic user management and authorization. No access levels, every user has
  access to all resources, and can create new users himself.
- Configuration of number of Unicorn worker processes and listen port.
- Ability to call (arbitrary) rake tasks, and open a ruby shell, in Docker
  container

### Changed

### Fixed

### Security

### Deprecated

### Removed


## [0.2.0] - 2016-09-10

### Added

- Support for accessing SolarLog stations via an SSH gateway, allowing secure
  access to a station outside of the current network.
- Timezone support:
  - Settings for storage of timestamps in database, and presentation in
    frontend.
  - Timezone setting for each SolarLog station, to properly unify timestamps.

### Changed

- Run container as non-privileged user

### Fixed

- Fix signal forwarding by using `exec` within docker entrypoint, ensuring the
- spawned process is a direct child of tini.


## [0.1.0] - 2016-09-05

### Added

- Management of [SolarLog](http://www.solar-log.com) stations.
  - Automated update of SolarLog station data.
- Management of [IFTTT](http://ifttt.com) Maker keys & events.
- Basic conditions, allowing to execute actions based on data of a SolarLog
  station.
