require "net/http"
require "uri"
require "json"

module Ruboty
	module YOLP
		class Client
			# env :YOLP_APP_ID, "your yolp application id."

			MAP_ENDPOINT= "http://map.olp.yahooapis.jp/OpenLocalPlatform/V1/static"
			GEO_ENDPOINT = "http://geo.search.olp.yahooapis.jp/OpenLocalPlatform/V1/geoCoder"

			YOLP_APP_ID = "dj0zaiZpPVFKRTc3a25OWlhUYSZzPWNvbnN1bWVyc2VjcmV0Jng9NmI-"

			def get_geoloc(place)
				params = {
					:appid => YOLP_APP_ID,
					:query => place,
					:output => "json",
					:results => 1
				}

				res = http_request("get", GEO_ENDPOINT, params)

				loc =  JSON.parse(res.body)["Feature"][0]["Geometry"]["Coordinates"].split(",")
			end

			def get_map(loc)
				params = {
					:appid => YOLP_APP_ID,
					:lat => loc[1].to_f,
					:lon => loc[0].to_f,
					:z => 12,
					:width => 800,
					:height => 600,
					:overlay => "type:rainfall"
				}
				query_string = build_query_string(params)

				MAP_ENDPOINT + "?#{query_string}"
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
