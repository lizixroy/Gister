require 'octokit'

class RawGistsParser
    DELIMITER = "$$$"
    def self.parse(filename)        
        begin
           content = File.readlines filename
           lines = Array.new
           content.each do |line| 
               lines << line
        end
        parse_lines(lines)
        rescue
           puts "file does not exist" 
           puts "exiting ..."
           exit
        end        
    end
    
    def self.parse_lines(lines) 
        parsed_lines = Array.new
        current_gist = Array.new        
        lines.each do |line|
            if line.gsub("\n", "") == DELIMITER
               unless current_gist.count == 0
                  parsed_lines << current_gist
                  current_gist = Array.new 
               end 
            else
                current_gist << line
            end
        end
        parsed_lines
    end
end

class RawGist           
   def initialize(options)
       @description = options[:description]
       @is_public = options[:is_public]
       @gist_name = options[:gist_name]
       @content = options[:content]
   end
   
   def format()
       {description: @description, public: @is_public, files: {@gist_name => {content: @content}}}
   end 
end

class RawGistPayloadFactory
   def self.create_raw_gist(options) 
      raw_gist_lines = options[:raw_gist_lines]
      description = options[:description] 
      gist_name_suffix = options[:gist_name_suffix]
      is_public = options[:is_public]      
      raw_gists = Array.new
      index = 0
      raw_gist_lines.each do |lines|          
          line = concat_lines(lines)
          raw_gists << RawGist.new({description: description, is_public: is_public, gist_name: "#{index}" + "." + gist_name_suffix, content: line}).format()
          index += 1
      end
      raw_gists
   end
   
   private    
   def self.concat_lines(lines)
       if lines.length == 0 
          return "" 
       end
       content = ""
       lines.each do |line|
          content += line 
       end
       content
   end
end

class CommandLineInterface
    GITHUB_ACCOUNT = "Please enter your Github username or email. (The Github account you want to create gists on)"
    GITHUB_PASSWORD = "Please enter you Github password. (Password is needed becasue creating gist requires authentication)"
    FILE_NAME = "Please enther the path to the file contains your input (Read README if you haven't)"
    DESCRIPTION = "Please enter description for your gists"
    GIST_NAME_SUFFIX = "Please enter name for gist. Please include extension for your gist so Github will highlight your code property (for example, article.swift)"
    IS_PUBLIC = "Enter 0 for private gist, enter 1 for public gist"
    
    def read_input 
       complete_reading = false
       while  !complete_reading do
           @github_username = nil
           @github_password = nil
           @file_name = nil
           @description = nil
           @gist_name_suffix = nil
           @is_public = nil
              
           @github_username = get_input(GITHUB_ACCOUNT)
           if @github_username.nil?
               display_error_message
               next
           end           
           @github_password = get_input(GITHUB_PASSWORD)
           if @github_password.nil?
              display_error_message
              next 
           end           
           @file_name = get_input(FILE_NAME)
           if @file_name.nil?
              display_error_message
              next 
           end           
           @description = get_input(DESCRIPTION)
           if @description.nil?
              display_error_message
              next 
           end
           @gist_name_suffix = get_input(GIST_NAME_SUFFIX)
           if @gist_name_suffix.nil?
              display_error_message              
              next 
           end           
           @is_public = get_input(IS_PUBLIC)      
           if @is_public.nil? || !validate_is_public(@is_public)
               display_error_message
               next
           end
           break
       end
       is_public = (@is_public == "1")
       return {github_username: @github_username, github_password: @github_password, file_name: @file_name, description: @description, gist_name_suffix: @gist_name_suffix, is_public: is_public}
    end
    
    private         
    def get_input(question)
        puts question
        answer_buffer = gets
        answer_buffer = answer_buffer.strip!
        return answer_buffer.length > 0 ? answer_buffer : nil
    end
    
    def validate_is_public(is_public)
        is_public == "0" || is_public == "1"
    end
    
    def display_error_message
       puts "Invalid input. Starting over..." 
    end
end

class Gister    
    def self.create_gists()
        command_line_interface = CommandLineInterface.new
        input = command_line_interface.read_input()
        parsed_lines = RawGistsParser.parse(input[:file_name])
        raw_gists = RawGistPayloadFactory.create_raw_gist({raw_gist_lines: parsed_lines, description: input[:description], gist_name_suffix: input[:gist_name_suffix], is_public: input[:is_public]})            
        client = nil
        puts "authenticating ..."    
        begin
            client = Octokit::Client.new \
              :login    => input[:github_username],
              :password => input[:github_password]
            user = client.user
            user.login                    
        rescue 
            puts "Authentication failure: bad credentials"
        end                    
        puts "creating gists now ... "        
        raw_gists.each do |raw_gist|            
           resource = client.create_gist(raw_gist)
           puts "gist created: #{resource.html_url}"
        end
    end
end

Gister.create_gists() if __FILE__ == $0