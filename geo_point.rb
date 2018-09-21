# Coordinate value object
# Example: GeoPoint.new(lat: 53.339428, lng: -6.257664)
class GeoPoint
  attr_reader :lat
  attr_reader :lng

  def initialize(lat:, lng:)
    raise ArgumentError, "Invalid lat: #{lat}" unless (-90..90).cover?(lat)
    raise ArgumentError, "Invalid lng: #{lng}" unless (-180..180).cover?(lng)

    @lat = lat
    @lng = lng
  end

  def lat_lng
    [@lat, @lng]
  end

  def lat_lng_in_radians
    [degress_to_radians(@lat), degress_to_radians(@lng)]
  end

  def to_s
    "#{@lat},#{@lng}"
  end

  private

  def degress_to_radians(deg)
    deg * Math::PI / 180.0
  end
end
