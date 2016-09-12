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

### TIMEZONE

Dealing with timezones can be rather frustrating, as the options available vary
depending on the database adapter.

With some adapters, you are able to use named timezones for the settings below
- these are timezones like `Europe/London` or `EST`.
With others you are limited to two options - `local` to use the server's local
time, and `utc` to use UTC. 

**Mind the capitalization!** `UTC` will use the
named-timezone for UTC, whereas `utc` will use the basic-behaviour UTC.

#### Recommended setup for named-timezone-capable adapters

* `TIMEZONE_DATABASE` = UTC
* `TIMEZONE_APPLICATION` = `Your/Local/Timezone`
* Do not set `TZ`

#### Recommended setup for non-named-timezone-capable adapters

* `TIMEZONE_DATABASE` = utc
* `TIMEZONE_APPLICATION` = local
* `TZ` = `Your/Local/Timezone`

This works (in my tests) well, at the cost of modifying the container's
timezone.

#### TIMEZONE_APPLICATION

*Default: utc*

Timezone which timestamps will be converted to when loaded from the database.
This is essentially the timezone you will see in the application's frontend.

It is advisable to set this to your local timezone - e.g. `Europe/London`.

#### TIMEZONE_TYPECAST

*Default: TIMEZONE_APPLICATION*

Timezone which unmarked timestamps will be assumed to be in. This might be the
case for user-input times.

It is advisable to use the same value as for `TIMEZONE_APPLICATION` in order
not to lead to unexpected results - the default value will do just that.

#### TIMEZONE_DATABASE

*Default: utc*

Timezone which to use for storing timestamps in the database. Also defines
which timezone timestamps stored in the database are assumed to be in, unless
they specify otherwise.

Do not change this value, unless you are certain of what you are doing.

### Database

#### DB_ADAPTER 

*Default: sqlite*

Define which DB adapter to use. Supported options:

* `mysql2` for MySQL
* `postgres` for Postgres
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

### UNICORN

#### UNICORN_LISTEN

*Default: 8080*

TCP port which unicorn will bind to.

#### UNICORN_WORKERS

*Default: 2*

Number of unicorn workers which to spawn.

In case of CPU-bound applications, this should be >= the number of the CPU
cores you have. If you are bound by memory, use as many as you can support.

If you have occasional slow jobs which are not CPU-bound, increasing it above
the number of CPU cores can be a good idea.

**Note**: Normally, unicorn can be told to increase/decrease the number of
workers by sending it a TTIN/TTOU signal. However, those are not relayed by
Tini, which means you must send the signal to the unicorn master directly, and
can not send it to the container.
