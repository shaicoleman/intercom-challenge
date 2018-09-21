#!/usr/bin/env ruby
require_relative 'invite_output'

puts InviteOutput.new(
  file_parser: FileParser.new(filename: 'customers.txt'),
  centre: GeoPoint.new(lat: 53.339428, lng: -6.257664),
  radius: 100_000
).run
