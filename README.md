# Louis XIV

Louis XIV is a small-ish application to help you with automating various
actions based on a [SolarLog](http://www.solar-log.com/)-monitored solar power
plant.

It integrates with [IFTTT](http://ifttt.com) via its `Maker` channel, with
planned support for other services.

## Usage

- Start by defining those SolarLog stations which you would like to monitor. For
  that, you simply need to know the URL of their HTTP interface.

- Hook up IFTTT by defining your Maker key, as well as those events
  which you would like to send.

- Create `Maker Actions` by combining Maker keys and Maker events.

- Define triggers, which fire when certain conditions of connected stations
  are fulfilled, and define which actions they should execute.

## Configuration

Following env variables can be set to configure Louis XIV.

### General

#### RACK_ENV

Rack environment which to use. Influences logging level, whether stacktraces
are shown, etc. Supported options:

- `production`
- `testing`
- `development`

Note: Strictly speaking, RACK_ENV influences **Rack**'s setup. However, Padrino
(and other tools) derive their default environment from it.

### Database

#### DB_ADAPTER 

*Default: sqlite*

Define which DB adapter to use. Supported options:

* `mysql2` for MySQL
* `pg` for Postgres
* `sqlite` for SQLite

#### DB_HOST

Hostname or IP address where the database server is at. Ignored for SQLite
databases.

#### DB_DATABASE 

*Default: db/louis_xiv_$ENV.db*

Name of the database which to use. Must exist already.

For SQLite, specify the path of the database file.

**The default value is only suitable for dev environments, not for production
use**

#### DB_USER

Database user with which to authenticate. Ignored for SQLite databases.

#### DB_PASS

Password of the database user with which to authenticate. Ignored for SQLite
databases.

### REDIS

#### REDIS_HOST 

*Default: localhost*

Hostname or IP address where the Redis server is at.

#### REDIS_PORT 

*Default: 6379*

Port of the Redis server.

### RESQUE

#### RESQUE_WEB

Optional URL where the Resque web-UI will be mounted. If undefined, UI will not
be mounted.

#### QUEUE

**Required**

Queues which the Resque worker will pull tasks from.

Use `*` to make it pull tasks from all queues.

#### INTERVAL 

*Library-default: 5*

Interval at which Resque workers pull for tasks, in seconds.

### RESQUE\_SCHEDULER\_INTERVAL 

*Library-default: 5*

Interval at which Resque's Scheduler checks whether there's tasks to be
schedule or executed.

