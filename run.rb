#!/env/ruby
require 'net/http'
require 'json'

uri = URI('http://localhost:3000/api/projects')

query_params = {
	:api_token => "password"
}

uri.query = URI.encode_www_form(query_params)

response = Net::HTTP.get_response(uri)
puts "Status: #{response.code}, #{response.message}"
puts "Body: #{response.body}"
