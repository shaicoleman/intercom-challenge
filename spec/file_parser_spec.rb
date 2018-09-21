require_relative '../file_parser'

RSpec.describe FileParser do
  describe '#run' do
    it 'parses customers.txt' do
      result = FileParser.new(filename: 'customers.txt').run
      expect(result.size).to eq(32)
      expect(result.dig(0, :name)).to eq('Christina McArdle')
      expect(result.dig(0, :user_id)).to eq(12)
      expect(result.dig(0, :coord).lat_lng).to eq([52.986375, -6.043701])
      expect(result.dig(-1, :name)).to eq('David Behan')
      expect(result.dig(-1, :user_id)).to eq(25)
      expect(result.dig(-1, :coord).lat_lng).to eq([52.833502, -8.522366])
    end

    it 'raises ReadError when file missing' do
      expect { FileParser.new(filename: 'error').run }.to raise_error(FileParser::ReadError)
    end

    it 'raises ParseError when JSON is invalid' do
      allow(File).to receive(:read).and_return('{')
      expect { FileParser.new(filename: '').run }.to raise_error(FileParser::ParseError)
    end

    it 'raises ParseError when coordinate is out of range' do
      contents = '{"user_id": 12, "latitude": "999", "longitude": "0"}'
      allow(File).to receive(:read).and_return(contents)
      expect { FileParser.new(filename: '').run }.to raise_error(FileParser::ParseError)
    end

    it 'raises ParseError when longitude is missing' do
      contents = '{"user_id": 12, "latitude": "0"}'
      allow(File).to receive(:read).and_return(contents)
      expect { FileParser.new(filename: '').run }.to raise_error(FileParser::ParseError)
    end

    it 'raises ParseError when user_id is missing' do
      contents = '{"user_id": "", "latitude": "0", "longitude": "0"}'
      allow(File).to receive(:read).and_return(contents)
      expect { FileParser.new(filename: '').run }.to raise_error(FileParser::ParseError)
    end

    it 'handles strings/integers/floats for latitude/longitude/user_id' do
      contents = <<~USERS
        {"latitude": 0.0, "user_id": 12, "longitude": 0}
        {"latitude": "33.3", "user_id": "013", "longitude": "-33.5"}
      USERS
      allow(File).to receive(:read).and_return(contents)
      result = FileParser.new(filename: '').run
      expect(result.dig(0, :coord).lat_lng).to eq([0, 0])
      expect(result.dig(0, :user_id)).to eq(12)
      expect(result.dig(1, :coord).lat_lng).to eq([33.3, -33.5])
      expect(result.dig(1, :user_id)).to eq(13)
    end

    it 'handles missing name as an empty string' do
      contents = '{"latitude": 0.0, "user_id": 12, "longitude": 0}'
      allow(File).to receive(:read).and_return(contents)
      result = FileParser.new(filename: '').run
      expect(result.dig(0, :name)).to eq('')
    end
  end
end
