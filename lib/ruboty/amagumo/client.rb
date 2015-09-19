require "net/http"
require "uri"
require "json"

module Ruboty
	module Amagumo
		class Client

			MAP_ENDPOINT= "http://map.olp.yahooapis.jp/OpenLocalPlatform/V1/static"
			LOC_ENDPOINT = "http://search.olp.yahooapis.jp/OpenLocalPlatform/V1/localSearch"

			def initialize(appid)
				@appid = appid
			end

			def get_map(place)
				loc = get_loc(place)

				if loc.nil?
					return "Error."
				end

				params = {
					:appid => @appid,
					:lat => loc[1].to_f,
					:lon => loc[0].to_f,
					:z => 12,
					:width => 800,
					:height => 600,
					:overlay => "type:rainfall"
					:pointer => "on"
				}
				query_string = build_query_string(params)

				MAP_ENDPOINT + "?#{query_string}"
			end

			private

			def get_loc(place)
				params = {
					:appid => @appid,
					:query => place,
					:output => "json",
					:results => 1
				}

				res = http_request("get", LOC_ENDPOINT, params)

				begin
					loc =  JSON.parse(res.body)["Feature"][0]["Geometry"]["Coordinates"].split(",")
				rescue => ex
					puts(ex.message)
					loc = nil
				end

				loc
			end

			def http_request(method, uri, params = {})
				uri = URI.parse(uri) if uri.is_a? String
				method = method.to_s.strip.downcase
				query_string = build_query_string(params)

				if method == "post"
					args = [Net::HTTP::Post.new(uri.path), query_string]
				else
					args = [Net::HTTP::Get.new(uri.path + (query_string.empty? ? "" : "?#{query_string}"))]
				end

				Net::HTTP.start(uri.host, uri.port) do |http|
					return http.request(*args)
				end
			end

			def build_query_string(params)
				query_string = (params||{}).map{|k,v|
					URI.encode(k.to_s) + "=" + URI.encode(v.to_s)
				}.join("&")
			end
		end
	end
end
