module Ruboty
	module Handlers
		class Amagumo < Base
			on(
				/amagumo (?<place>.*?)\z/,
				name: "amagumo",
				description: "Get the rain_map from Yahoo! Amagumo-Zoom-Rader."
			)

			def amagumo(message)
				amagumo = Ruboty::Amagumo.Client.new
				loc = amagumo.get_geoloc(message[:place])
				url = amagumo.get_map(loc)
				message.reply(url)
			end
	end
end
