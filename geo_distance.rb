# Distance Calculation between two geo-points
class GeoDistance
  # Radius source: https://en.wikipedia.org/wiki/Earth_radius#Mean_radius
  EARTH_MEAN_RADIUS = 6_371_009 # metres

  # Spherical distance calculation between two GeoPoints (max error: 0.5%)
  # Earth is a spheroid. Use geodesic distance if accuracy is needed
  # Implementation based on geopy.distance.great_circle
  #
  # Example:
  # GeoDistance.sphere GeoPoint.new(lat: 53.3, lng: -6.2), GeoPoint.new(lat: 53.0, lng: -6.1)
  def self.sphere(point1, point2)
    lat1, lng1 = point1.lat_lng_in_radians
    lat2, lng2 = point2.lat_lng_in_radians

    sin_lat1 = Math.sin(lat1)
    sin_lat2 = Math.sin(lat2)
    cos_lat1 = Math.cos(lat1)
    cos_lat2 = Math.cos(lat2)
    sin_delta_lng = Math.sin(lng2 - lng1)
    cos_delta_lng = Math.cos(lng2 - lng1)

    atan_y = Math.sqrt((cos_lat2 * sin_delta_lng)**2 +
                       (cos_lat1 * sin_lat2 - sin_lat1 * cos_lat2 * cos_delta_lng)**2)
    atan_x = sin_lat1 * sin_lat2 + cos_lat1 * cos_lat2 * cos_delta_lng
    Math.atan2(atan_y, atan_x) * EARTH_MEAN_RADIUS
  end
end
