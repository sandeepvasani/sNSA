class HomeController < ApplicationController
require 'rubygems'
require 'net/http'
require 'json'

 def index
uri = URI("https://gov.blockscore.com/api/people")
response = Net::HTTP.get(uri)
@res=JSON.parse(response)
  end
end

