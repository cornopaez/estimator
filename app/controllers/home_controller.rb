include ActionView::Helpers::NumberHelper

class HomeController < ApplicationController

	require 'pokitdok'
	require 'dotenv'
	require "uri"
	require "awesome_print"

	Dotenv.load("config.env")

	def home
	end

	def query

		# Get params in usable form
		procedure = params["procedure"]
		zipcode = params["zip"]

		# Values for Medicare data query
		strings = [
			"$select=hcpcs_description,stddev_pop(average_submitted_charge_amount),AVG(average_submitted_charge_amount),MAX(average_submitted_charge_amount),MIN(average_submitted_charge_amount)",
			"&$group=hcpcs_description",
			"&$where=hcpcs_description='" + params["procedure"] + "'"
		]

		token = {"$$app_token" => ENV["SOCRATA_TOKEN"]}

		# Medicare data
		response = HTTParty.get(
			"https://data.cms.gov/resource/cng4-92f3.json?" + URI.encode(strings.join), 
			:data => token
		)

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

		# PokitDok Code
		# client_id = ENV["POKITDOK_CLIENT_ID"]
		# client_secret = ENV["POKITDOK_CLIENT_SECRET"]
		# pd = PokitDok::PokitDok.new(client_id, client_secret)
		# @pokit_providers = pd.providers({zipcode: zipcode, specialty: 'Orthopaedic Surgery', radius: '3mi', sort: "rank"})

		@pokit_providers = {"meta"=>{"processing_time"=>377, "application_mode"=>"production", "credits_billed"=>1, "credits_remaining"=>14, "rate_limit_cap"=>5000, "rate_limit_reset"=>1489507326, "rate_limit_amount"=>4, "activity_id"=>"58c809f1a308b608aed73441", "next"=>"https://platform.pokitdok.com/api/v4/providers/?radius=5mi&sort=rank&specialty=Orthopaedic+Surgery&zipcode=15211&offset=20", "result_count"=>186}, "data"=>[{"provider"=>{"uuid"=>"f7ce9ff1-b191-4340-a188-ce23e1b4a5a7", "npi"=>"1659652428", "entity_type"=>"individual", "prefix"=>"DR", "first_name"=>"Nicholas", "middle_name"=>"Joseph", "last_name"=>"Greco", "gender"=>"Male", "locations"=>[{"city"=>"Pittsburgh", "address_lines"=>["3471 5th Ave", "Suite 911"], "zipcode"=>"15213", "county"=>"Allegheny", "phone"=>"4126053262", "state"=>"PA", "geo_location"=>[-79.960375, 40.440406], "suite"=>"911"}], "phone"=>"4126053262", "fax"=>"4126873724", "degree"=>"MD", "specialty"=>["Orthopaedic Surgery", "Surgery", "Surgery - Orthopaedic"], "specialty_primary"=>["Surgery - Orthopaedic"], "specialty_secondary"=>["Physician"], "licenses"=>[{"state"=>"PA", "number"=>"MT200217"}], "verified"=>false}}, {"provider"=>{"uuid"=>"f616b21b-14f9-433c-9232-f1e0aa4612b2", "npi"=>"1932435872", "entity_type"=>"organization", "organization_name"=>"Orthopedic Group, PC", "locations"=>[{"city"=>"Pittsburgh", "fax"=>"4122768557", "address_lines"=>["1145 Bower Hill Rd", "Suite 301"], "zipcode"=>"15243", "county"=>"Allegheny", "phone"=>"4122767022", "state"=>"PA", "geo_location"=>[-80.068654, 40.375719], "suite"=>"301"}], "phone"=>"4122767022", "fax"=>"4122768557", "specialty"=>["Orthopaedic Surgery", "Surgery"], "specialty_primary"=>["Orthopaedic Surgery"], "specialty_secondary"=>["Allopathic and Osteopathic Physicians (MD/DO)"], "verified"=>false}}, {"provider"=>{"uuid"=>"49f59029-af67-4b1a-a478-611672f281df", "npi"=>"1114332327", "entity_type"=>"individual", "first_name"=>"Nicholas", "middle_name"=>"John", "last_name"=>"Vaudreuil", "gender"=>"Male", "locations"=>[{"city"=>"Pittsburgh", "fax"=>"4126873724", "address_lines"=>["3471 5th Ave", "Suite 911"], "zipcode"=>"15213", "county"=>"Allegheny", "phone"=>"4126053262", "state"=>"PA", "geo_location"=>[-79.960375, 40.440406], "suite"=>"911"}], "phone"=>"4126053262", "fax"=>"4126873724", "degree"=>"MD", "specialty"=>["Orthopaedic Surgery", "Surgery", "Surgery - Orthopaedic"], "specialty_primary"=>["Surgery - Orthopaedic"], "specialty_secondary"=>["Physician"], "licenses"=>[{"state"=>"PA", "number"=>"MT206268"}], "verified"=>false}}, {"provider"=>{"uuid"=>"af1a5406-da72-4e2c-b70e-2d7acade564e", "npi"=>"1245644400", "entity_type"=>"individual", "first_name"=>"Mitchell", "middle_name"=>"Stephen", "last_name"=>"Fourman", "gender"=>"Male", "locations"=>[{"city"=>"Pittsburgh", "address_lines"=>["3471 5th Ave", "Suite 911"], "zipcode"=>"15213", "county"=>"Allegheny", "phone"=>"6315139369", "state"=>"PA", "geo_location"=>[-79.960375, 40.440406], "suite"=>"911"}], "phone"=>"6315139369", "degree"=>"MD", "specialty"=>["Orthopaedic Surgery", "Surgery", "Surgery - Orthopaedic"], "specialty_primary"=>["Surgery - Orthopaedic"], "specialty_secondary"=>["Physician"], "licenses"=>[{"state"=>"PA", "number"=>"MT205933"}], "verified"=>false}}, {"provider"=>{"uuid"=>"fd5ce415-77fb-41b9-997e-e52aab04de62", "npi"=>"1437509643", "entity_type"=>"individual", "first_name"=>"Steven", "last_name"=>"De Groot", "suffix"=>"Jr", "gender"=>"Male", "locations"=>[{"city"=>"Pittsburgh", "address_lines"=>["2504A Sidney St"], "zipcode"=>"15203", "county"=>"Allegheny", "phone"=>"4042819424", "state"=>"PA", "geo_location"=>[-79.969156, 40.428653]}, {"city"=>"Pittsburgh", "address_lines"=>["3471 5th Ave"], "zipcode"=>"15213", "county"=>"Allegheny", "phone"=>"4126053262", "state"=>"PA", "geo_location"=>[-79.960375, 40.440406]}], "phone"=>"4126053262", "degree"=>"MD", "specialty"=>["Orthopaedic Surgery", "Surgery", "Surgery - Orthopaedic"], "specialty_primary"=>["Surgery - Orthopaedic"], "specialty_secondary"=>["Physician"], "licensures"=>[{"status"=>"active", "verified"=>"N", "number"=>"MT210758", "state"=>"PA"}], "licenses"=>[{"state"=>"PA", "number"=>"MT210758"}], "verified"=>false}}, {"provider"=>{"uuid"=>"99ea4e3f-e28e-4e26-93a8-c236804a5871", "npi"=>"1336329929", "entity_type"=>"organization", "organization_name"=>"Jon B Tucker MD PC", "locations"=>[{"city"=>"Pittsburgh", "address_lines"=>["1145 Bower Hill Rd", "Suite 302"], "zipcode"=>"15243", "county"=>"Allegheny", "phone"=>"4123106177", "state"=>"PA", "geo_location"=>[-80.068654, 40.375719], "suite"=>"302"}], "phone"=>"4123106177", "fax"=>"4122767215", "specialty"=>["Orthopaedic Surgery", "Surgery"], "specialty_primary"=>["Orthopaedic Surgery"], "specialty_secondary"=>["Allopathic and Osteopathic Physicians (MD/DO)"], "verified"=>false}}, {"provider"=>{"uuid"=>"6170ff5a-f187-47a0-81e2-dbf48df1634a", "npi"=>"1447454434", "entity_type"=>"individual", "first_name"=>"Volker", "last_name"=>"Musahl", "gender"=>"Male", "locations"=>[{"city"=>"Pittsburgh", "fax"=>"4126873724", "address_lines"=>["3471 5th Ave", "Suite 1010"], "zipcode"=>"15213", "county"=>"Allegheny", "phone"=>"4126053267", "state"=>"PA", "geo_location"=>[-79.960375, 40.440406], "suite"=>"1010"}], "phone"=>"4126053267", "fax"=>"4126873724", "degree"=>"MD", "specialty"=>["Orthopaedic Surgery", "Surgery", "Surgery - Orthopaedic"], "specialty_primary"=>["Surgery - Orthopaedic"], "specialty_secondary"=>["Physician"], "licensures"=>[{"status"=>"active", "verified"=>"Y", "expiration_date"=>"2018-12-31", "number"=>"MD434618", "state"=>"PA"}], "licenses"=>[{"state"=>"NY", "number"=>"249711"}, {"state"=>"PA", "number"=>"MT181396"}], "verified"=>false}}, {"provider"=>{"uuid"=>"07e89e98-dd3f-44ab-adc8-c175998d51a5", "npi"=>"1295957132", "entity_type"=>"individual", "prefix"=>"DR", "first_name"=>"Andrew", "middle_name"=>"Man-Lap", "last_name"=>"Ho", "gender"=>"Male", "locations"=>[{"city"=>"Pittsburgh", "address_lines"=>["3471 5th Ave", "Suite 1010"], "zipcode"=>"15213", "county"=>"Allegheny", "phone"=>"4126873900", "state"=>"PA", "geo_location"=>[-79.960375, 40.440406], "suite"=>"1010"}, {"city"=>"Pittsburgh", "address_lines"=>["200 Lothrop St"], "zipcode"=>"15213", "county"=>"Allegheny", "phone"=>"4126473087", "state"=>"PA", "geo_location"=>[-79.961735, 40.442335]}], "phone"=>"4126873900", "degree"=>"MD", "specialty"=>["Orthopaedic Surgery", "Surgery", "Surgery - Orthopaedic"], "specialty_primary"=>["Surgery - Orthopaedic"], "specialty_secondary"=>["Physician"], "licensures"=>[{"status"=>"active", "verified"=>"Y", "expiration_date"=>"2017-11-30", "number"=>"00104685", "state"=>"CA"}], "licenses"=>[{"state"=>"PA", "number"=>"MD431535"}], "verified"=>false}}, {"provider"=>{"uuid"=>"c178cb34-14b7-4283-91d4-9de8cce16103", "npi"=>"1730518366", "entity_type"=>"organization", "organization_name"=>"St. Clair Medical Services, Inc.", "other_organization_name"=>"Tucker Orthopedics Division", "locations"=>[{"city"=>"Pittsburgh", "address_lines"=>["1082 Bower Hill Rd", "Suite 100"], "zipcode"=>"15243", "county"=>"Allegheny", "phone"=>"4122766241", "state"=>"PA", "geo_location"=>[-80.067605, 40.376386], "suite"=>"100"}], "phone"=>"4122766241", "specialty"=>["Orthopaedic Surgery", "Surgery"], "specialty_primary"=>["Orthopaedic Surgery"], "specialty_secondary"=>["Allopathic and Osteopathic Physicians (MD/DO)"], "website_url"=>"www.pnc.com", "verified"=>false}}, {"provider"=>{"uuid"=>"571b60d0-794c-44a8-afb7-07f6cf5949c0", "npi"=>"1376981282", "entity_type"=>"individual", "first_name"=>"Julie", "middle_name"=>"Elizabeth", "last_name"=>"Johnson", "gender"=>"Female", "locations"=>[{"city"=>"Pittsburgh", "address_lines"=>["3471 5th Ave", "Suite 1010"], "zipcode"=>"15213", "county"=>"Allegheny", "phone"=>"4126053262", "state"=>"PA", "geo_location"=>[-79.960375, 40.440406], "suite"=>"1010"}], "phone"=>"4126053262", "degree"=>"MD", "specialty"=>["Orthopaedic Surgery", "Surgery", "Surgery - Orthopaedic"], "specialty_primary"=>["Surgery - Orthopaedic"], "specialty_secondary"=>["Physician"], "licenses"=>[{"state"=>"PA", "number"=>"MT204050"}], "verified"=>false}}, {"provider"=>{"uuid"=>"57e9f4ac-44d8-4a28-9b5d-8dfecec4b5ae", "npi"=>"1477785269", "entity_type"=>"individual", "first_name"=>"Gele", "middle_name"=>"B", "last_name"=>"Moloney", "gender"=>"Female", "locations"=>[{"city"=>"Pittsburgh", "fax"=>"4126873724", "address_lines"=>["3471 5th Ave", "Suite 911"], "zipcode"=>"15213", "county"=>"Allegheny", "phone"=>"4126472345", "state"=>"PA", "geo_location"=>[-79.960375, 40.440406], "suite"=>"911"}], "phone"=>"4126472345", "fax"=>"4126873724", "degree"=>"MD", "specialty"=>["Orthopaedic Surgery", "Surgery", "Surgery - Orthopaedic"], "specialty_primary"=>["Surgery - Orthopaedic"], "specialty_secondary"=>["Physician"], "licenses"=>[{"state"=>"PA", "number"=>"MT195027"}], "verified"=>false}}, {"provider"=>{"uuid"=>"205cc59e-d82d-4575-85eb-ff850984592b", "npi"=>"1306108436", "entity_type"=>"individual", "prefix"=>"DR", "first_name"=>"Adam", "middle_name"=>"Clay", "last_name"=>"Rothenberg", "gender"=>"Male", "locations"=>[{"city"=>"Pittsburgh", "fax"=>"4126870802", "address_lines"=>["3471 5th Ave"], "zipcode"=>"15213", "county"=>"Allegheny", "phone"=>"4126053203", "state"=>"PA", "geo_location"=>[-79.960375, 40.440406]}], "phone"=>"4126053203", "fax"=>"4126870802", "degree"=>"MD", "specialty"=>["Orthopaedic Surgery", "Surgery", "Surgery - Orthopaedic"], "specialty_primary"=>["Surgery - Orthopaedic"], "specialty_secondary"=>["Physician"], "licenses"=>[{"state"=>"PA", "number"=>"MT201097"}], "verified"=>false}}, {"provider"=>{"uuid"=>"4a169c37-9019-4892-849f-b32310ee33ba", "npi"=>"1003817107", "entity_type"=>"individual", "prefix"=>"DR", "first_name"=>"Nicholas", "middle_name"=>"George", "last_name"=>"Sotereanos", "birth_date"=>"1960", "gender"=>"Male", "locations"=>[{"city"=>"Pittsburgh", "fax"=>"4123598055", "address_lines"=>["1307 Federal St"], "zipcode"=>"15212", "county"=>"Allegheny", "phone"=>"8776606777", "state"=>"PA", "geo_location"=>[-80.007197, 40.457154]}], "phone"=>"8776606777", "fax"=>"4123598055", "degree"=>"MD", "specialty"=>["Orthopaedic Surgery", "Surgery", "Surgery - Orthopaedic"], "specialty_primary"=>["Surgery - Orthopaedic"], "specialty_secondary"=>["Physician"], "licensures"=>[{"status"=>"active", "verified"=>"Y", "expiration_date"=>"2018-12-31", "number"=>"MD040499E", "state"=>"PA"}, {"status"=>"active", "verified"=>"Y", "expiration_date"=>"2018-10-31", "number"=>"0101049649", "state"=>"VA"}], "licenses"=>[{"state"=>"PA", "number"=>"MD040499E"}], "residencies"=>[{"institution_name"=>"Hahnemann University School Of Medicine", "to_year"=>"1986", "type"=>"Medical School"}, {"institution_name"=>"University Of Pittsburgh Medical Center", "to_year"=>"1994", "type"=>"Residency"}, {"institution_name"=>"University Health Center Pittsburgh", "to_year"=>"1987", "type"=>"Internship"}], "education"=>{"medical_school"=>"Hahnemann University School Of Medicine", "graduation_year"=>"1986"}, "board_certifications"=>["Surgery - Orthopaedic"], "facilities"=>[{"organization_name"=>"Allegheny General Hospital", "npi"=>"1588683296"}, {"organization_name"=>"Kindred Hospital Pittsburgh-North Shore", "npi"=>"1144391756"}], "verified"=>false}}, {"provider"=>{"uuid"=>"ed41327a-37b9-4af0-95fa-4d9340b9597f", "npi"=>"1851772586", "entity_type"=>"individual", "first_name"=>"Bryan", "last_name"=>"Rynearson", "gender"=>"Male", "locations"=>[{"city"=>"Pittsburgh", "fax"=>"4126873724", "address_lines"=>["3471 5th Ave", "Suite 1010"], "zipcode"=>"15213", "county"=>"Allegheny", "phone"=>"4126053233", "state"=>"PA", "geo_location"=>[-79.960375, 40.440406], "suite"=>"1010"}], "phone"=>"4126053233", "fax"=>"4126873724", "degree"=>"MD", "specialty"=>["Orthopaedic Surgery", "Surgery", "Surgery - Orthopaedic"], "specialty_primary"=>["Surgery - Orthopaedic"], "specialty_secondary"=>["Physician"], "licenses"=>[{"state"=>"PA", "number"=>"MT208161"}], "verified"=>false}}, {"provider"=>{"uuid"=>"5e7f9f27-3498-4c92-964b-dad2ed5ed9ba", "npi"=>"1104231059", "entity_type"=>"individual", "prefix"=>"DR", "first_name"=>"David", "last_name"=>"Hirsch", "gender"=>"Male", "locations"=>[{"city"=>"Pittsburgh", "address_lines"=>["3471 5th Ave"], "zipcode"=>"15213", "county"=>"Allegheny", "phone"=>"4126053202", "state"=>"PA", "geo_location"=>[-79.960375, 40.440406]}], "phone"=>"4126053202", "degree"=>"MDO", "specialty"=>["Orthopaedic Surgery", "Surgery", "Surgery - Orthopaedic"], "specialty_primary"=>["Surgery - Orthopaedic"], "specialty_secondary"=>["Physician"], "licenses"=>[{"state"=>"PA", "number"=>"MT206683"}], "verified"=>false}}, {"provider"=>{"uuid"=>"fd887bb6-48dd-452c-aef8-9db41f60996a", "npi"=>"1427408699", "entity_type"=>"individual", "first_name"=>"Stephanie", "last_name"=>"Maestre", "gender"=>"Female", "locations"=>[{"city"=>"Pittsburgh", "address_lines"=>["331 S Negley Ave", "Suite 5"], "zipcode"=>"15232", "county"=>"Allegheny", "phone"=>"7863761166", "state"=>"PA", "geo_location"=>[-79.9327, 40.4597], "suite"=>"5"}, {"city"=>"Pittsburgh", "address_lines"=>["3471 5th Ave"], "zipcode"=>"15213", "county"=>"Allegheny", "phone"=>"4126053262", "state"=>"PA", "geo_location"=>[-79.960375, 40.440406]}], "phone"=>"4126053262", "degree"=>"MDO", "specialty"=>["Orthopaedic Surgery", "Surgery", "Surgery - Orthopaedic"], "specialty_primary"=>["Surgery - Orthopaedic"], "specialty_secondary"=>["Physician"], "licensures"=>[{"status"=>"active", "verified"=>"N", "number"=>"MT211450", "state"=>"PA"}], "licenses"=>[{"state"=>"PA", "number"=>"MT211450"}], "verified"=>false}}, {"provider"=>{"uuid"=>"6068fa2a-43af-4212-b879-401e31ea85a6", "npi"=>"1790886083", "entity_type"=>"organization", "organization_name"=>"Renaissance Orthopaedics PC", "locations"=>[{"city"=>"Pittsburgh", "fax"=>"4126830341", "address_lines"=>["300 Halket St"], "zipcode"=>"15213", "county"=>"Allegheny", "phone"=>"4126837272", "state"=>"PA", "geo_location"=>[-79.95894, 40.436562]}], "phone"=>"4126837272", "fax"=>"4126830341", "specialty"=>["Orthopaedic Surgery", "Surgery"], "specialty_primary"=>["Orthopaedic Surgery"], "specialty_secondary"=>["Allopathic and Osteopathic Physicians (MD/DO)"], "verified"=>false}}, {"provider"=>{"uuid"=>"6683a2e0-fb34-4800-b9da-e271902755c7", "npi"=>"1003850363", "entity_type"=>"organization", "organization_name"=>"Greater Pittsburgh Orthopaedic Associates Inc", "locations"=>[{"city"=>"Pittsburgh", "fax"=>"4126614760", "address_lines"=>["5820 Centre Ave"], "zipcode"=>"15206", "county"=>"Allegheny", "phone"=>"4126615500", "state"=>"PA", "geo_location"=>[-79.930385, 40.458326]}], "phone"=>"4126615500", "fax"=>"4126614760", "specialty"=>["Orthopaedic Surgery", "Surgery"], "specialty_primary"=>["Orthopaedic Surgery"], "specialty_secondary"=>["Allopathic and Osteopathic Physicians (MD/DO)"], "licenses"=>[{"state"=>"PA", "number"=>"========="}], "website_url"=>"www.gpoa.com", "verified"=>false}}, {"provider"=>{"uuid"=>"622b3b73-ad39-42e0-af19-8b388784409d", "npi"=>"1023371168", "entity_type"=>"individual", "prefix"=>"DR", "first_name"=>"Patrick", "middle_name"=>"Joseph", "last_name"=>"Ward", "suffix"=>"Iii", "gender"=>"Male", "locations"=>[{"city"=>"Pittsburgh", "address_lines"=>["3471 5th Ave"], "zipcode"=>"15213", "county"=>"Allegheny", "state"=>"PA", "geo_location"=>[-79.960375, 40.440406]}], "phone"=>"4126053203", "degree"=>"MDO", "specialty"=>["Orthopaedic Surgery", "Surgery", "Surgery - Orthopaedic"], "specialty_primary"=>["Surgery - Orthopaedic"], "specialty_secondary"=>["Physician"], "licenses"=>[{"state"=>"PA", "number"=>"MT201822"}], "verified"=>false}}, {"provider"=>{"uuid"=>"aef65680-4eb9-4900-a07b-9dfb999c0837", "npi"=>"1093788127", "entity_type"=>"individual", "prefix"=>"DR", "first_name"=>"Freddie", "middle_name"=>"H", "last_name"=>"Fu", "birth_date"=>"1950", "gender"=>"Male", "locations"=>[{"city"=>"Pittsburgh", "fax"=>"4124323690", "address_lines"=>["3200 S Water St"], "zipcode"=>"15203", "county"=>"Allegheny", "phone"=>"4124323611", "state"=>"PA", "geo_location"=>[-79.958981, 40.424499]}], "phone"=>"4124323611", "fax"=>"4124323690", "degree"=>"MD", "specialty"=>["Orthopaedic Surgery", "Surgery", "Surgery - Orthopaedic"], "specialty_primary"=>["Surgery - Orthopaedic"], "specialty_secondary"=>["Physician"], "licensures"=>[{"status"=>"active", "verified"=>"Y", "expiration_date"=>"2018-12-31", "number"=>"MD021519E", "state"=>"PA"}], "licenses"=>[{"state"=>"PA", "number"=>"MD021519E"}], "residencies"=>[{"institution_name"=>"University Of Pittsburgh", "to_year"=>"1982", "type"=>"Residency"}, {"to_year"=>"1977", "type"=>"Medical School"}], "education"=>{"graduation_year"=>"1977"}, "facilities"=>[{"organization_name"=>"Center For Rehabilitation Services"}, {"organization_name"=>"Magee-Women's Hospital of UPMC", "npi"=>"1952311508"}, {"organization_name"=>"UPMC South Side"}], "verified"=>false}}]}

		# Google Maps Information
		@google_maps_key = ENV["GOOGLE_MAPS_KEY"]

		@markers = Array.new

		
		@pokit_providers["data"].each do |item|

			text = "#{item["provider"]["first_name"]} #{item["provider"]["last_name"]}"

			if text.length == 1
				text = "#{item["provider"]["organization_name"]}"
			end

			itemDetails = Hash.new
			itemDetails["lat"] = item["provider"]["locations"][0]["geo_location"][1].to_f
			itemDetails["lng"] = item["provider"]["locations"][0]["geo_location"][0].to_f
			itemDetails["infowindow"] = text

			@markers.push itemDetails
		end

	end

end