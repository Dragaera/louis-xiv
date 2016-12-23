FROM ruby:2.3.3

MAINTAINER Michael Senn <michael@morrolan.ch>

# True for application server, but worker and scheduler don't actually expose
# any ports. :/
EXPOSE 8080

# Tiny Init. (Reap zombies, forward signals)
ENV TINI_VERSION v0.13.2
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Create non-privileged user
RUN groupadd -r louis && useradd -r -g louis louis

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
# Throw error if Gemfile was modified after Gemfile.lock
RUN bundle config --global frozen 1
# Installing gems before copying source allows caching of gem installation.
COPY Gemfile Gemfile.lock /usr/src/app/
RUN bundle install
COPY . /usr/src/app

RUN chmod +x "./docker-entrypoint.sh"

USER louis
ENTRYPOINT ["/tini", "--", "./docker-entrypoint.sh"]
