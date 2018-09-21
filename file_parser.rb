require 'json'

# Reads and parses a customer file into an array of hashes
# Example: FileParser.new(filename: 'customers.txt').run
class FileParser
  class ReadError < StandardError; end
  class ParseError < StandardError; end

  def initialize(filename:)
    @filename = filename
  end

  def run
    read
    parse
  end

  private

  def read
    @contents = File.read(@filename)
  rescue StandardError => e
    raise ReadError, "Error reading file #{@filename}: #{e}"
  end

  def parse
    @contents.each_line.map.with_index(1) do |line, lineno|
      parse_line(line)
    rescue StandardError => e
      raise ParseError, "Error parsing #{@filename} on line #{lineno}: #{e}"
    end
  end

  def parse_line(line)
    parsed = JSON.parse(line)
    # Float()/Integer() validate input before conversion
    # Integer(num, 10) ensures that it doesn't get interpreted as octal
    { user_id: Integer(parsed['user_id'].to_s, 10),
      name: parsed['name'].to_s,
      coord: GeoPoint.new(lat: Float(parsed['latitude']),
                          lng: Float(parsed['longitude'])) }
  end
end
