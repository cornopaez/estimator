include ActionView::Helpers::NumberHelper

class HomeController < ApplicationController

	require 'pokitdok'
	require 'dotenv'
	require "uri"
	# require "awesome_print"

	Dotenv.load("config.env")

	def home
	end

	def query

		# PokitDok Code
		# client_id = ENV["POKITDOK_CLIENT_ID"]
		# client_secret = ENV["POKITDOK_CLIENT_SECRET"]
		# pd = PokitDok::PokitDok.new(client_id, client_secret)
		# @pokit = pd.plans({state: 'PA'})

		# Values for Medicare data query
		strings = [
			"$select=hcpcs_description,stddev_pop(average_submitted_charge_amount),AVG(average_submitted_charge_amount),MAX(average_submitted_charge_amount),MIN(average_submitted_charge_amount)",
			"&$group=hcpcs_description",
			"&$where=hcpcs_description='" + params["procedure"] + "'"
		]

		# Medicare data
		response = HTTParty.get("https://data.cms.gov/resource/cng4-92f3.json?" + URI.encode(strings.join))

		# Initial values from data
		avg = response[0]["AVG_average_submitted_charge_amount"].to_f
		stddev = response[0]["stddev_pop_average_submitted_charge_amount"].to_f
		low = response[0]["MIN_average_submitted_charge_amount"].to_f
		high = response[0]["MAX_average_submitted_charge_amount"].to_f
		high_price = high <= (avg + (stddev * 2)) ? high : avg + (stddev * 2)
		low_price = (avg - (stddev * 2)) <= low ? low : avg - (stddev * 2)

		# Values to render
		@procedure_name = response[0]["hcpcs_description"]
		@average_price = number_to_currency(avg)
		@high_price = number_to_currency(high_price)
		@low_price = number_to_currency(low_price)
		@left = ((230 * (avg - low_price)) / (high_price - low_price)) + 50

		# Google Maps Information
		@google_maps_key = ENV["GOOGLE_MAPS_KEY"]

	end

end