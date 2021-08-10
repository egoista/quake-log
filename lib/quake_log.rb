# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require 'json'

Dir["#{File.dirname(__FILE__)}/quake_log/**/*.rb"].each { |file| require file }

module QuakeLog
end
