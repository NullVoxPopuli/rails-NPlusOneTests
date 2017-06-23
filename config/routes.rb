Rails.application.routes.draw do
  get '/ams/base', to: 'ams/base#test_endpoint'
  get '/ams/base/eager', to: 'ams/base#test_manual_eagerload'
  get '/ams/api', to: 'ams/api#test_endpoint'
  get '/ams/api/eager', to: 'ams/api#test_manual_eagerload'

  get '/ams/metal', to: 'ams/metal#test_endpoint'
  get '/ams/metal/eager', to: 'ams/metal#test_manual_eagerload'

  get '/jsonapi/base', to: 'jsonapi_rb/base#test_endpoint'
  get '/jsonapi/base/eager', to: 'jsonapi_rb/base#test_manual_eagerload'
  get '/jsonapi/api', to: 'jsonapi_rb/api#test_endpoint'
  get '/jsonapi/api/eager', to: 'jsonapi_rb/api#test_manual_eagerload'
  get '/jsonapi/metal', to: 'jsonapi_rbmetal#test_endpoint'
  get '/jsonapi/metal/eager', to: 'jsonapi_rbmetal#test_manual_eagerload'
end
