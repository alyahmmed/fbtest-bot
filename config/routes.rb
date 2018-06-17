Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	
  match '/', to: 'welcome#index' , via: :all
  match '*path', to: 'application#_404', via: :all
end
