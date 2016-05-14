require 'test_helper'

describe 'GithubMock' do
  it 'should not hook request when path is not /oauth/github' do
    get '/'
    last_response.status.must_equal 200
    last_response.body.must_equal 'DUMMY APP'
  
    get '/oauth'
    last_response.status.must_equal 200
    last_response.body.must_equal 'DUMMY APP'
  
    get '/oauth/twitter'
    last_response.status.must_equal 200
    last_response.body.must_equal 'DUMMY APP'
  end
  
  it 'should hook request for /oauth/github and redirect to callback' do
    get '/oauth/github'
    last_response.status.must_equal 301
    last_response.headers['Location'].must_equal '/oauth/callback?provider=github'
  end

  it 'should stub external request for acquiring GitHub access token' do
    app # load Rack app to enable WebMock stubbing
    conn = Faraday.new(url: 'https://github.com') do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end
    response = conn.post '/login/oauth/access_token'

    response.body.must_equal 'access_token=charleslutwidgedodgson&scope=user%2Cgist&token_type=bearer'
  end

  it 'should stub external request for acquiring GitHub user information' do
    expected = Rack::AliceInExternal::GithubMock.new(app).send(:user_info)
  
    conn = Faraday.new(url: 'https://api.github.com') do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end
    response = conn.get '/user'
  
    response.body.must_equal expected
  end
end
