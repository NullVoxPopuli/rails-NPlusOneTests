require 'benchmark/ips'
require 'awesome_print'
require 'active_support'
require 'pry-byebug'
require 'kalibera'
require 'benchmark-memory'
require 'rake'
require 'rails'
require 'jsonapi/rails'
# require 'jsonapi/rails/deserializable_resource'

benchmarks = %i[ips memory]

require './config/environment'

GC.disable

hash = {
  data: {
    id: 1,
    type: 'posts',
    attributes: {
      name: 'a post',
      text: 'some text',
      description: 'some description',
      longer_text: '
        longer text longer text longer text longer text longer text longer text
        longer text longer text longer text longer text longer text longer
        text longer text longer text longer text longer text longer text longer
        text longer text longer text longer text longer text longer text
        longer text longer text longer text longer text longer text longer text
        longer text longer text longer text longer text longer text longer text
        longer text longer text longer text longer text longer text longer text
        longer text longer text longer text longer text longer text longer text
        longer text longer text longer text longer text longer text longer text
      ',
      bool_field: false,
      number_field: 0,
      null_field: nil,
      empty_field: '',
      array_field: %w[array of stuff],
      object_field: { custom: 'thing' }
    },
    relationships: {
      author: { data: { id: 1, type: 'users' } },
      comments: {
        data: [
          { id: 1, type: 'comments' },
          { id: 2, type: 'comments' },
          { id: 3, type: 'comments' }
        ]
      }
    }
  }
}

indifferent = hash.with_indifferent_access
data = indifferent['data']

ams_deserialize = lambda {
  ActiveModelSerializers::Adapter::JsonApi::Deserialization.parse(indifferent)
}

jsonapi_deserialize = lambda {
  # JSONAPI::Rails::DeserializableResource.call(json)
  JSONAPI::Rails::Deserializable::Resource.call(data)
}

benchmarks.each do |bench|
  Benchmark.send(bench) do |x|
    x.config(time: 10, warmup: 5, stats: :bootstrap, confidence: 95) if x.respond_to?(:config)

    x.report('ams       ') { ams_deserialize.call }
    x.report('jsonapi-rb') { jsonapi_deserialize.call }

    x.compare!
  end
end
