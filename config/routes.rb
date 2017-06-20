Rails.application.routes.draw do
  get '/base', to: 'base#test_endpoint'

  get '/api', to: 'api#test_endpoint'

  get '/metal', to: 'metal#test_endpoint'
end
