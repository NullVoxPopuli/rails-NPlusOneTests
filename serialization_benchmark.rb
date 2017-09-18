require 'benchmark/ips'
require 'awesome_print'
require 'pry-byebug'
require 'kalibera'
require 'benchmark-memory'
require 'rake'

benchmarks = %i[ips memory]

$env_vars = []
# WITH_OJ
#  WITH_GOLDILOADER
# 'WITH_RUST_EXTENSIONS'
options = [''] + $env_vars

scenarios = options.permutation(2).to_a.map(&:sort).uniq
scenarios.unshift([])

def start_scenario(scenario)
  ActiveRecord::Base.remove_connection

  data_config = {
    comments_per_post: 20,
    posts: 20
  }

  $env_vars.each { |v| ENV.delete(v) unless v.empty? }
  scenario.each { |v| ENV[v] = 'true' unless v.empty? }

  ENV['RAILS_ENV'] = 'development'

  puts `bundle install; bundle exec rake db:drop db:create db:migrate`
  ActiveRecord::Base.establish_connection

  u = User.create(first_name: 'Diana', last_name: 'Prince', birthday: 3000.years.ago)

  data_config[:posts].times do
    p = Post.create(user_id: u.id, title: 'Some Post', body: 'awesome content')
    data_config[:comments_per_post].times do
      Comment.create(author: 'me', comment: 'nice blog', post_id: p.id)
    end
  end
end

require './config/environment'

# GC.disable

module Bench
  module_function

  def test_render(render_gem)
    render_data(
      User.first,
      render_gem
    )
  end

  def test_auto_eagerload(render_gem)
    render_data(
      User.auto_include(true).first,
      render_gem
    )
  end

  def test_manual_eagerload(render_gem)
    render_data(
      # User.auto_include(false).includes(posts: [:comments]).first,
      User.includes(posts: [:comments]).first,
      render_gem
    )
  end

  def render_data(data, render_gem)
    return render_with_ams(data) if render_gem == :ams

    render_with_jsonapi_rb(data)
  end

  def render_with_ams(data)
    ActiveModelSerializers::SerializableResource.new(
      data,
      include: 'posts.comments',
      # fields: params[:fields],
      adapter: :json_api
    ).as_json
  end

  def render_with_jsonapi_rb(data)
    JSONAPI::Serializable::Renderer.new.render(
      data,
      include: 'posts.comments',
      class: {
        User: SerializableUser,
        Post: SerializablePost,
        Comment: SerializableComment
      }
    )
  end
end

GC.disable

scenarios.each do |scenario|
  start_scenario(scenario)

  # Convert the ENV / gem setup to strings for the reporter
  named_parts = scenario
                .map { |s| s.gsub('WITH_', '') }
                .reject(&:empty?)

  scenario_title = named_parts.join(',').ljust(10, ' ').to_s

  benchmarks.each do |bench|
    Benchmark.send(bench) do |x|
      x.config(time: 10, warmup: 5, stats: :bootstrap, confidence: 95) if x.respond_to?(:config)

      x.report("ams              #{scenario_title}") { Bench.test_render(:ams) }
      x.report("jsonapi-rb       #{scenario_title}") { Bench.test_render(:jsonapi_rb) }
      # x.report("ams        goldi #{scenario_title}") { Bench.test_auto_eagerload(:ams) }
      # x.report("jsonapi-rb goldi #{scenario_title}") { Bench.test_auto_eagerload(:jsonapi_rb) }
      x.report("ams        eager #{scenario_title}") { Bench.test_manual_eagerload(:ams) }
      x.report("jsonapi-rb eager #{scenario_title}") { Bench.test_manual_eagerload(:jsonapi_rb) }

      x.compare!
    end
  end
end
