Rails.application.routes.draw do
  get '/base', to: 'base#test_endpoint'
  get '/api', to: 'api#test_endpoint'
  get '/metal', to: 'metal#test_endpoint'

  get '/jsonapi-base', to: 'base#jsonapi_rb'
  get '/jsonapi-api', to: 'api#jsonapi_rb'
  get '/jsonapi-metal', to: 'metal#jsonapi_rb'
end
