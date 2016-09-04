FROM ruby:2.3.1-onbuild

MAINTAINER Michael Senn <michael@morrolan.ch>

RUN chmod +x "./docker-entrypoint.sh"

# Tiny Init. (Reap zombies, forward signals)
ENV TINI_VERSION v0.10.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ENTRYPOINT ["/tini", "--", "./docker-entrypoint.sh"]
