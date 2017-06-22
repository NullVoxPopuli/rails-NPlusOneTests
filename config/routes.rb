Rails.application.routes.draw do
  get '/ams/base', to: 'ams/base#test_endpoint'
  get '/ams/api', to: 'ams/api#test_endpoint'
  get '/ams/metal', to: 'ams/metal#test_endpoint'

  get '/jsonapi/base', to: 'jsonapi_rb/base#test_endpoint'
  get '/jsonapi/api', to: 'jsonapi_rb/api#test_endpoint'
  get '/jsonapi/metal', to: 'jsonapi_rbmetal#test_endpoint'
end
