require_relative '../geo_point'

RSpec.describe GeoPoint do
  describe '#new' do
    it 'returns expected values' do
      point = GeoPoint.new(lat: 53.349722, lng: -6.260278)
      expect(point.lat).to eq(53.349722), '#lat'
      expect(point.lng).to eq(-6.260278), '#lng'
      expect(point.lat_lng).to eq([53.349722, -6.260278]), '#lat_lng'
      expect(point.to_s).to eq('53.349722,-6.260278'), '#to_s'
      expect(point.lat_lng_in_radians[0]).to be_within(0.001).of(0.931), '#lat_lng_in_radians (lat)'
      expect(point.lat_lng_in_radians[1]).to be_within(0.001).of(-0.109), '#lat_lng_in_radians (lng)'
    end

    it 'raises ArgumentError when latitude/longitude is invalid' do
      expect { GeoPoint.new(lat: 100, lng: 20) }.to raise_error(ArgumentError)
      expect { GeoPoint.new(lat: 33, lng: -200) }.to raise_error(ArgumentError)
      expect { GeoPoint.new(lat: '', lng: 2) }.to raise_error(ArgumentError)
      expect { GeoPoint.new(lat: nil, lng: 2) }.to raise_error(ArgumentError)
    end

    it 'works with min/max/zero coordinates' do
      expect(GeoPoint.new(lat: 0, lng: 0).lat_lng).to eq([0, 0])
      expect(GeoPoint.new(lat: 90, lng: 0).lat_lng).to eq([90, 0])
      expect(GeoPoint.new(lat: -90, lng: 0).lat_lng).to eq([-90, 0])
      expect(GeoPoint.new(lat: 0, lng: 180).lat_lng).to eq([0, 180])
      expect(GeoPoint.new(lat: 0, lng: -180).lat_lng).to eq([0, -180])
    end
  end
end
