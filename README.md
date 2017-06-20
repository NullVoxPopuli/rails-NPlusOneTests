# Performance Testing Different JSONAPI setups.

This repo is intended to demonstrate the differences between various ways of setting up an api.

Planned Scenarios:

 - with and without oj
 - with and without goldiloader

Against:

 - ActionController::Base
 - ActionController::API
 - ActionController::Metal (with minimum required to render json)
 - ActionCable

All rendering JSONAPI.org-format JSON.


TODO:
 - Action Cable
 - Metal
 - jsonapi-rb instead of active_model_serializers
 - with and without case_transform-rust-extensions
   - only speeds up active_model_serializers when case transforming is used (serialize/deserialize)
