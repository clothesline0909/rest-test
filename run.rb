#!/env/ruby
require 'net/http'
require 'json'

uri = URI('http://localhost:3000/api/1.0/projects')
response = Net::HTTP.post_form(uri, "name" => "fourth project")
puts "Status: #{response.code}, #{response.message}"
puts "Body: #{response.body}"
