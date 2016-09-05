#!/usr/bin/env rackup
# encoding: utf-8

# This file can be used to start Padrino,
# just execute it from the command line.

require File.expand_path('../config/boot.rb', __FILE__)

require 'resque/server'


url_map = {
  '/' => Padrino.application
}

resque_web_path = ENV['RESQUE_WEB']
url_map[resque_web_path] = Resque::Server.new if resque_web_path

run Rack::URLMap.new(url_map)

