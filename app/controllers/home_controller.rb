class HomeController < ApplicationController

	require 'pokitdok'
	require 'dotenv'
	Dotenv.load("config.env")

	def home
		# client_id = ENV["POKITDOK_CLIENT_ID"]
		# client_secret = ENV["POKITDOK_CLIENT_SECRET"]
		# pd = PokitDok::PokitDok.new(client_id, client_secret)
		# @pokit = pd.plans({state: 'PA'})
	end

end