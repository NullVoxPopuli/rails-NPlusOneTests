require 'benchmark/ips'
require 'awesome_print'
require 'pry-byebug'
require 'kalibera'
require 'benchmark-memory'


`bundle exec rake db:drop db:create db:migrate`

def create_dummy_data!
  data_config = {
    comments_per_post: 2,
    posts: 100
  }

  u = User.create(first_name: 'Diana', last_name: 'Prince', birthday: 3000.years.ago)

  data_config[:posts].times do
    p = Post.create(user_id: u.id, title: 'Some Post', body: 'awesome content')
    data_config[:comments_per_post].times do
      Comment.create(author: 'me', comment: 'nice blog', post_id: p.id)
    end
  end
end

require './config/environment'
create_dummy_data!

GC.disable

module BenchJSONAPI
  module_function

  def test_render
    render_data(User.first)
  end

  def test_manual_eagerload
    render_data(User.includes(posts: [:comments]).first)
  end

  def render_data(data)
    json = JSONAPI::Serializable::SuccessRenderer.new.render(
      data,
      include: 'posts.comments',
      # fields: params[:fields] || [],
      class: SerializableUser
    )

    json.to_json
  end
end

module BenchAMS
  module_function

  def test_render
    render_data(User.first)
  end

  def test_manual_eagerload
    render_data(User.includes(posts: [:comments]).first)
  end

  def render_data(data)
    ActiveModelSerializers::SerializableResource.new(
      data,
      include: 'posts.comments',
      # fields: params[:fields],
      adapter: :json_api
    ).as_json
  end
end

%i[ips memory].each do |bench|
  Benchmark.send(bench) do |x|
    # x.config(time: 15, warmup: 4, stats: :bootstrap, confidence: 95)

    x.report('ams             ') { BenchAMS.test_render }
    x.report('jsonapi-rb      ') { BenchJSONAPI.test_render }
    x.report('ams        eager') { BenchAMS.test_manual_eagerload }
    x.report('jsonapi-rb eager') { BenchJSONAPI.test_manual_eagerload }

    x.compare!
  end
end
