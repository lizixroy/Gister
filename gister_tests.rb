require_relative 'gister.rb'
require "test/unit"

class RawGistsParserTests < Test::Unit::TestCase
    def test_parse_lines_with_no_delimiter
       lines = ["line1", "line2", "line3"]
       parsed_lines = RawGistsParser.parse_lines(lines)
       expected_parsed_lines_count = 0
       assert_not_nil(parsed_lines)
       assert_equal(expected_parsed_lines_count, parsed_lines.length)
    end
    
    def test_parse_lines_with_1delimiter_but_no_content
        lines = ["$$$"]
        parsed_lines = RawGistsParser.parse_lines(lines)
        expected_parsed_lines_count = 0
        assert_not_nil(parsed_lines)
        assert_equal(expected_parsed_lines_count, parsed_lines.length)        
    end
    
    def test_parse_lines
        lines = ["line1", "$$$", "line2", "$$$"]
        
        expected_description = "example description"
        expected_gist_name_suffix = "gist_name.swift"
        
        parsed_lines = RawGistsParser.parse_lines(lines)
        
        expected_parsed_lines_count = 2
        assert_not_nil(parsed_lines)
        assert_equal(expected_parsed_lines_count, parsed_lines.length)            
        
        parsed_line_0 = parsed_lines[0][0]
        parsed_line_1 = parsed_lines[1][0]
        
        assert_equal("line1", parsed_line_0)        
        assert_equal("line2", parsed_line_1)
    end
    
    def test_parse_lines_with_redundant_lines
        lines = ["line1", "$$$", "line2", "$$$", "line3"]
        
        expected_description = "example description"
        expected_gist_name_suffix = "gist_name.swift"
        
        parsed_lines = RawGistsParser.parse_lines(lines)
        
        expected_parsed_lines_count = 2
        assert_not_nil(parsed_lines)
        assert_equal(expected_parsed_lines_count, parsed_lines.length)            
        
        parsed_line_0 = parsed_lines[0][0]
        parsed_line_1 = parsed_lines[1][0]
        
        assert_equal("line1", parsed_line_0)        
        assert_equal("line2", parsed_line_1)
    end

    def test_parse_lines_with_redundant_delimiter
        lines = ["$$$", "line1", "$$$", "line2", "$$$"]
        
        expected_description = "example description"
        expected_gist_name_suffix = "gist_name.swift"
        
        parsed_lines = RawGistsParser.parse_lines(lines)
        
        expected_parsed_lines_count = 2
        assert_not_nil(parsed_lines)
        assert_equal(expected_parsed_lines_count, parsed_lines.length)            
        
        parsed_line_0 = parsed_lines[0][0]
        parsed_line_1 = parsed_lines[1][0]
        
        assert_equal("line1", parsed_line_0)        
        assert_equal("line2", parsed_line_1)
    end

    def test_parse_lines_with_multiple_lines
        lines = ["line1", "line2", "line3", "$$$"]
        
        expected_description = "example description"
        expected_gist_name_suffix = "gist_name.swift"
        
        parsed_lines = RawGistsParser.parse_lines(lines)
        
        expected_parsed_lines_count = 1
        assert_not_nil(parsed_lines)
        assert_equal(expected_parsed_lines_count, parsed_lines.length)            
        
        expected_count = 3
        parsed_line = parsed_lines[0]
        assert_equal(expected_count, parsed_line.count)
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