$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rack/alice_in_external'

require 'minitest/autorun'
require 'minitest/spec'
require 'rack'
require 'rack/test'
require 'faraday'
require 'rack/alice_in_external'

class Minitest::Test
  include Rack::Test::Methods

  def app
    @app ||= Rack::Builder.new do
      use Rack::AliceInExternal::GithubMock
      run lambda { |env| [200, {}, ['DUMMY APP']] }
    end.to_app
  end
end
