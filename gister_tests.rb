require_relative 'gister.rb'
require "test/unit"

class RawGistsParserTests < Test::Unit::TestCase
    def test_parse_lines_with_no_delimiter
       lines = ["line1", "line2", "line3"]
       raw_gists = RawGistsParser.parse_lines(lines)
       expected_raw_gists_count = 0
       assert_not_nil(raw_gists)
       asset_equal(expected_raw_gists_count, raw_gists.length)
    end
end

class RawGistTests < Test::Unit::TestCase
    def test_format()        
        description = "description"
        is_public = true
        gist_name = "gist_name.rb"
        content = "content"        
        raw_gist = RawGist.new({description: description, is_public: is_public, gist_name: gist_name, content: content})
        expected_formatted_raw_gist = {description: description, public: is_public, files: {gist_name => {content: content}}}
        assert_equal(expected_formatted_raw_gist, raw_gist.format)
    end
end