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
        
    end
end

puts RawGistsParser.parse("file.txt")

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

# this class interacts with user through a command line interface
class CommandLineInterface
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