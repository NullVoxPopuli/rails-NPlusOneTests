# https://github.com/evanphx/benchmark-ips
require 'benchmark/ips'
require 'awesome_print'

env_vars = [ 'WITH_OJ',
              'WITH_GOLDILOADER'
             # 'WITH_RUST_EXTENSIONS'
]
options = [''] + env_vars


scenarios = options.permutation(2).to_a.map(&:sort).uniq
scenarios.unshift([])


def create_dummy_data!
  comments = "rand(1..4).times { Comment.create(author: 'me', comment: 'nice blog', post_id: p.id)}"
  commands = [
    "u = User.create(first_name: 'Diana', last_name: 'Prince', birthday: 3000.years.ago)",
    "100.times { p = Post.create(user_id: u.id, title: 'Some Post', body: 'awesome content'); #{comments}}"
  ]
  cmd = commands.join(';')

  `export RAILS_ENV=production; export RAILS_MAX_THREADS=10`
  `rm -rf tmp/pids`
  ap "making server"
  # be sure to get all the deps
  `WITH_RUST_EXTENSIONS=true WITH_OJ=true WITH_GOLDILOADER=true bundle install`
  `DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=production rake db:drop db:create db:migrate`
  `RAILS_ENV=production rails runner "#{cmd}"`
end

def new_server
  port = rand(12000..19000)
  s = "RAILS_ENV=production bundle exec rails s --port #{port} --pid $(pwd)/tmp/pids/p#{port}.pid"
  pid = spawn(s)
  Process.detach(pid)

  [port, pid]
end


create_dummy_data!

headers = '-H "Accept: application/vnd.api+json" -H "Content-Type: application/vnd.api+json"'
params = '?include=posts.comments'


pids = []
Benchmark.ips do |x|
  x.config(time: 15, warmup: 4)

  scenarios.each do |scenario|
    ap scenario
    named_parts = scenario
      .map{|s| s.gsub('WITH_', '')}
      .select{|s| s.length > 0}

    scenario_title = "#{named_parts.join(',').ljust(30, ' ')}"


    # Set up vars
    env_vars.each { |v| ENV.delete(v) if v.length > 0 }
    scenario.each { |v| ENV[v] = 'true' if v.length > 0 }
    port, pid = new_server
    pids << pid

    url = "localhost:#{port}"
    base_request = "curl #{headers} --silent #{url}/base#{params} > /dev/null"
    api_request = "curl #{headers} --silent #{url}/api#{params} > /dev/null"
    metal_request = "curl #{headers} --silent #{url}/metal#{params} > /dev/null"

    jbase_request = "curl #{headers} --silent #{url}/jsonapi-base#{params} > /dev/null"
    japi_request = "curl #{headers} --silent #{url}/jsonapi-api#{params} > /dev/null"
    jmetal_request = "curl #{headers} --silent #{url}/jsonapi-metal#{params} > /dev/null"

    sleep(10) # seconds

    x.report("#{scenario_title} -- ActionController::Base") { `#{base_request}` }
    #x.report("#{scenario_title} -- ActionController::API") { `#{api_request}` }
    #x.report("#{scenario_title} -- ActionController::Metal") { `#{metal_request}` }

    x.report("jsonapi-rb #{scenario_title} -- ActionController::Base") { `#{jbase_request}` }
   # x.report("jsonapi-rb #{scenario_title} -- ActionController::API") { `#{japi_request}` }
   # x.report("jsonapi-rb #{scenario_title} -- ActionController::Metal") { `#{jmetal_request}` }

    x.compare!
  end
end

pids.each { |pid| Process.kill("HUP", pid) }

