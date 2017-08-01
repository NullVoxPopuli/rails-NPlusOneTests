require 'benchmark/ips'
require 'awesome_print'
require 'pry-byebug'
require 'kalibera'



$data_config = {
  comments_per_post: 2,
  posts: 100
}

env_vars = [ 'WITH_OJ',
            #  'WITH_GOLDILOADER',
          # 'WITH_RUST_EXTENSIONS'
]
options = [''] + env_vars


scenarios = options.permutation(2).to_a.map(&:sort).uniq
scenarios.unshift([])
`bundle exec rake db:drop db:create db:migrate`

def create_dummy_data!
    u = User.create(first_name: 'Diana', last_name: 'Prince', birthday: 3000.years.ago)

    $data_config[:posts].times {
      p = Post.create(user_id: u.id, title: 'Some Post', body: 'awesome content');
      $data_config[:comments_per_post].times {
        Comment.create(author: 'me', comment: 'nice blog', post_id: p.id)
      }
    }
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
    json = JSONAPI::Serializable::Renderer.render(
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

Benchmark.ips do |x|
  x.config(time: 15, warmup: 4, stats: :bootstrap, confidence: 95)


  x.report('ams             ') { BenchAMS.test_render }
  x.report('jsonapi-rb      ') { BenchJSONAPI.test_render }
  x.report('ams        eager') { BenchAMS.test_manual_eagerload }
  x.report('jsonapi-rb eager') { BenchJSONAPI.test_manual_eagerload }

  x.compare!
end
