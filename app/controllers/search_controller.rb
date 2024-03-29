class SearchController < ApplicationController
require 'rubygems'
require 'net/http'
require 'json'
require 'geocoder'	#require to geocode ip

RAD_PER_DEG = 0.017453293  #  PI/180  
# the great circle distance d will be in whatever units R is in  
  
Rkm = 6371              # earth's radius in kilometers
def self.haversine_distance( lat1, lon1, lat2, lon2 )  
#haversine_distance method referred from http://www.codecodex.com/wiki/Calculate_distance_between_two_points_on_a_globe  
  dlon = lon2 - lon1  
  dlat = lat2 - lat1  
   
  dlon_rad = dlon * RAD_PER_DEG  
  dlat_rad = dlat * RAD_PER_DEG  
   
  lat1_rad = lat1 * RAD_PER_DEG  
  lon1_rad = lon1 * RAD_PER_DEG  
   
  lat2_rad = lat2 * RAD_PER_DEG  
  lon2_rad = lon2 * RAD_PER_DEG  
   
  a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2  
  c = 2 * Math.asin( Math.sqrt(a))  
   
  return Rkm * c             # delta in kilometers  
 
end 

def index

uri = URI("https://gov.blockscore.com/api/people")
response = Net::HTTP.get(uri)
res=JSON.parse(response)
@fir=params[:first_name]
@las=params[:last_name]
ip=params[:ip_address]
@location = Geocoder.search(ip)
ip_longitude=@location[0].longitude
ip_latitude=@location[0].latitude
@phone_ip=-1.0
@stated_ip=-1.0
@stated_phone=-1.0
res.each do |child|
  if child['first_name']==@fir and child['last_name']==@las	
	
	phone_latitude=child['phone_location']['latitude']
	phone_longitude=child['phone_location']['longitude']
	@phone_ip=	self.class.haversine_distance( ip_latitude, ip_longitude, phone_latitude, phone_longitude )
	
	stated_latitude=child['stated_location']['latitude']
	stated_longitude=child['stated_location']['longitude']
	@stated_ip=self.class.haversine_distance( ip_latitude, ip_longitude, stated_latitude, stated_longitude )
	
	@stated_phone=self.class.haversine_distance(stated_latitude, stated_longitude, phone_latitude, phone_longitude )
	
  end
end

end 
end


