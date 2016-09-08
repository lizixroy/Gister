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
        lines
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
            if line == DELIMITER
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
   attr_reader :description, :is_public, :gist_name, :content
    
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
      description = options[:descriptoin] 
      gist_name_suffix = options[:gist_name_suffix]
      is_public = options[:is_public]      
      raw_gists = Array.new
      index = 0
      raw_gist_lines.each do |lines|
          line = concat_lines(lines)
          raw_gists << RawGist.new({description: description, is_public: is_public, gist_name: "#{index}" + "." + gist_name_suffix, content: line}).format()
      end
      raw_gists
   end
   
   private    
   def self.concat_lines(lines)
       if lines.count == 0 
          return "" 
       end
       content = ""
       lines.each do |line|
          content += line 
       end
       content
   end
end

# this class interacts with user through a command line interface
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
       return {github_username: @github_username, github_password: @github_password, file_name: @file_name, description: @description, gist_name_suffix: @gist_name_suffix, is_public: @is_public}
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

# this class connects everything together
class Gister
end

# client = Octokit::Client.new \
#   :login    => 'li1471@purdue.edu',
#   :password => 'ZENGxiaolin1964'
#
# user = client.user
# user.login
#
# file_content = "
# class Example {
#     let name: String
#     int(name: String) {
#         self.name = name
#     }
# }
# "

# resource = (client.create_gist({public: true, files: {"example_from_ruby_2.swift": { "content": file_content }}}))
#
# puts resource.class
#
# for key, value in resource
#    puts "#{key}: #{value}"
# end

cli = CommandLineInterface.new
input = cli.read_input()
puts input