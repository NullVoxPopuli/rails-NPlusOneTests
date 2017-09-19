# frozen_string_literal: true

require 'benchmark/ips'
require 'awesome_print'
require 'active_support'
require 'pry-byebug'
require 'kalibera'
require 'benchmark-memory'
require 'rake'
require 'rails'
require 'jsonapi/deserializable'
require 'jsonapi/serializable'
require 'jsonapi/rails'
require 'active_model_serializers'
# require 'jsonapi/rails/deserializable/resource'

benchmarks = %i[ips memory]

require './config/environment'

def custom_parsing(json)
  result = {}
  result['id'] = json['id'] if json['id']

  result.merge!(json['attributes'])

  json['relationships'].each do |relation_name, v|
    data = v['data']
    if data.is_a?(Array)
      result[relation_name] = data.map do |relationship|
        {
          "#{relation_name.singularize}_id" => relationship['id'],
          "#{relation_name.singularize}_type" => relationship['type']
        }
      end
    else
      result["#{relation_name}_id"] = data['id']
      result["#{relation_name}_type"] = data['type']
    end
  end

  result
end

# Disable Validation
module ActiveModelSerializers::Adapter::JsonApi::Deserialization
  class << self
    def validate_payload(_document)
      # TODO: modify this to accept embedded documents
      true
    end
  end
end

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
      # author: { data: { id: 1, type: 'users' } },
      # user: { data: { id: 2, type: 'users' } },
      # comments: {
      #   data: [
      #     { id: 1, type: 'comments' },
      #     { id: 2, type: 'comments' },
      #     { id: 3, type: 'comments' }
      #   ]
      # }
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

custom = lambda {
  custom_parsing(data)
}

GC.disable

# ap 'outputs'
# ap 'ams'
# ap ams_deserialize.call
# ap 'jsonapi'
# ap jsonapi_deserialize.call
# ap 'custom'
# ap custom.call

benchmarks.each do |bench|
  Benchmark.send(bench) do |x|
    x.config(time: 10, warmup: 5, stats: :bootstrap, confidence: 95) if x.respond_to?(:config)

    x.report('ams       ') { ams_deserialize.call }
    x.report('jsonapi-rb') { jsonapi_deserialize.call }
    x.report('custom    ') { custom.call }

    x.compare!
  end
end
