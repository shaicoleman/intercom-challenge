require_relative 'file_parser'
require_relative 'geo_point'
require_relative 'geo_distance'

# Reads and parses a customer file into an array of hashes
# Example:
# InviteOutput.new(
#   file_parser: FileParser.new(filename: 'customers.txt'),
#   centre: GeoPoint.new(lat: 53.3, lng: -6.2),
#   radius: 100_000
# ).run
class InviteOutput
  def initialize(file_parser:, centre:, radius:)
    @file_parser = file_parser
    @centre = centre
    @radius = radius
  end

  def run
    find_invitees
    generate_output
  end

  private

  def find_invitees
    @invitees = @file_parser.run \
                            .select { |rec| within_radius(rec) } \
                            .sort_by { |rec| rec[:user_id] }
  end

  def within_radius(rec)
    GeoDistance.sphere(rec[:coord], @centre) <= @radius
  end

  def generate_output
    radius_km = (@radius / 1000.0).round(3)
    output = "Inviting users within #{radius_km} km of #{@centre}:\n"
    @invitees.map do |user|
      output << "User #{user[:user_id]}: #{user[:name]} @#{user[:coord]}\n"
    end
    output
  end
end
