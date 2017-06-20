# https://github.com/evanphx/benchmark-ips
require 'benchmark/ips'
require 'awesome_print'

env_vars = [ 'WITH_OJ', 'WITH_GOLDILOADER' ]
options = [''] + env_vars

scenarios = options.permutation(2).to_a.map(&:sort).uniq
scenarios.unshift([])


def create_dummy_data!
  comments = "2.times { Comment.create(author: 'me', comment: 'nice blog', post_id: p.id)}"
  commands = [
    "u = User.create(first_name: 'Diana', last_name: 'Prince', birthday: 3000.years.ago)",
    "50.times { p = Post.create(user_id: u.id, title: 'Some Post', body: 'awesome content'); #{comments}}"
  ]
  cmd = commands.join(';')

  `bundle`
  `DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=production rake db:drop db:create db:migrate`
  `RAILS_ENV=production rails runner "#{cmd}"`
end


create_dummy_data!

headers = '-H "Accept: application/vnd.api+json" -H "Content-Type: application/vnd.api+json"'
params = '?include=posts.comments'


pids = []
Benchmark.ips do |x|
  x.config(time: 15, warmup: 4)

  scenarios.each do |scenario|
    ap scenario
    port = rand(12000..19000)
    url = "localhost:#{port}"

    base_request = "curl #{headers} --silent #{url}/base#{params} > /dev/null"
    api_request = "curl #{headers} --silent #{url}/api#{params} > /dev/null"
    metal_request = "curl #{headers} --silent #{url}/metal#{params} > /dev/null"

    # Set up vars
    env_vars.each { |v| ENV[v] = '' if v.length > 0 }
    scenario.each { |v| ENV[v] = 'true' if v.length > 0 }
    s = "rm -rf tmp/pids && bundle install && RAILS_ENV=production bundle exec rails s --port #{port}"
    pid = spawn(s)
    Process.detach(pid)
    pids << pid

    sleep(10) # seconds

    x.report("#{scenario.join(',').ljust(30, ' ')} -- ActionController::Base") { `#{base_request}` }
    x.report("#{scenario.join(',').ljust(30, ' ')} -- ActionController::API") { `#{api_request}` }
    # x.report("#{scenario.join(',')} -- ActionController::Metal") { `#{metal_request}` }

    x.compare!
  end
end
pids.each { |pid| Process.kill("HUP", pid) }

`kill -2 #{$server_process_id}`
