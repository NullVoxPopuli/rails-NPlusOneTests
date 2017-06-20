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
 - jsonapi-rb instead of active_model_serializers
 - with and without case_transform-rust-extensions
   - only speeds up active_model_serializers when case transforming is used (serialize/deserialize)


### Results

#### 2017-06-20

```
# 1 user, 100 posts, rand(1..4) comments per post
GOLDILOADER,OJ     -- ActionController::Metal:       68.2 i/s
GOLDILOADER        -- ActionController::Metal:       67.0 i/s - same-ish: difference falls within error
                   -- ActionController::Metal:       65.4 i/s - same-ish: difference falls within error
OJ                 -- ActionController::Metal:       64.6 i/s - same-ish: difference falls within error
GOLDILOADER        -- ActionController::API:       62.6 i/s - 1.09x  slower
GOLDILOADER,OJ     -- ActionController::API:       61.7 i/s - 1.11x  slower
OJ                 -- ActionController::Base:       61.1 i/s - 1.12x  slower
                   -- ActionController::Base:       60.6 i/s - 1.12x  slower
GOLDILOADER,OJ     -- ActionController::Base:       60.5 i/s - 1.13x  slower
OJ                 -- ActionController::API:       59.2 i/s - 1.15x  slower
GOLDILOADER        -- ActionController::Base:       58.1 i/s - 1.17x  slower
                   -- ActionController::API:       55.8 i/s - 1.22x  slower
```
