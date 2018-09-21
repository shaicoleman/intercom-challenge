require_relative '../invite_output'

RSpec.describe InviteOutput do
  describe '#run' do
    it 'Output contains the matched users, sorted by user_id' do
      output = InviteOutput.new(
        file_parser: FileParser.new(filename: 'customers.txt'),
        centre: GeoPoint.new(lat: 53.339428, lng: -6.257664),
        radius: 100_000
      ).run
      output_user_ids = output.scan(/^User (\d+):/).flatten
      expect(output_user_ids).to eq(%w[4 5 6 8 11 12 13 15 17 23 24 26 29 30 31 39])
    end
  end
end
