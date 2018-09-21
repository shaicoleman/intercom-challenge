require_relative '../geo_point'
require_relative '../geo_distance'

# expected results checked against the geopy implementation, e.g.
# from geopy.distance import great_circle
# great_circle((53.339428, -6.257664), (52.986375, -6.043701)).meters

RSpec.describe GeoDistance do
  describe '#sphere' do
    it 'distance Dublin => London (~464km)' do
      point1 = GeoPoint.new(lat: 53.349722, lng: -6.260278)
      point2 = GeoPoint.new(lat: 51.507222, lng: -0.1275)
      distance = GeoDistance.sphere(point1, point2)
      expect(distance).to be_within(0.001).of(463_334.589)
    end

    it 'distance Madrid => Wellington (~19,853km)' do
      point1 = GeoPoint.new(lat: 40.383333, lng: -3.716667)
      point2 = GeoPoint.new(lat: -41.288889, lng: 174.777222)
      distance = GeoDistance.sphere(point1, point2)
      expect(distance).to be_within(0.001).of(19_853_274.913)
    end

    it 'distance is order insensitive' do
      point1 = GeoPoint.new(lat: 53.349722, lng: -6.260278)
      point2 = GeoPoint.new(lat: 51.507222, lng: -0.1275)
      distance1 = GeoDistance.sphere(point1, point2)
      distance2 = GeoDistance.sphere(point2, point1)
      expect(distance1).to be_within(0.001).of(distance2)
    end

    it 'distance of same location returns zero' do
      point = GeoPoint.new(lat: 53.349722, lng: -6.260278)
      distance = GeoDistance.sphere(point, point)
      expect(distance).to be_within(0.001).of(0)
    end

    it 'checks longitude wrapping same point' do
      point1 = GeoPoint.new(lat: 53.339428, lng: -180)
      point2 = GeoPoint.new(lat: 53.339428, lng: 180)
      distance = GeoDistance.sphere(point1, point2)
      expect(distance).to be_within(0.001).of(0)
    end

    it 'distance between poles (~20,015km)' do
      point1 = GeoPoint.new(lat: 90, lng: 0)
      point2 = GeoPoint.new(lat: -90, lng: 0)
      distance = GeoDistance.sphere(point1, point2)
      expect(distance).to be_within(0.001).of(20_015_115.070)
    end
  end
end
