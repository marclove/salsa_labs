module Fixtures
  def fixture_file(filename)
    File.new("spec/fixtures/#{filename}")
  rescue Errno::ENOENT
    nil
  end
end
