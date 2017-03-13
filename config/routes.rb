Rails.application.routes.draw do
	get "home" => "home#home"

	get "/" => "home#query"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
