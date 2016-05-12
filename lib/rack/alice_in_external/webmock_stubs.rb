require 'webmock'

include WebMock::API

# Stubbing external request for GitHub OAuth via WebMock
stub_request(:post, 'https://github.com/login/oauth/access_token')
  .to_return(body: 'access_token=charleslutwidgedodgson&scope=user%2Cgist&token_type=bearer',
             headers: { 'content-type' => 'application/x-www-form-urlencoded' })

stub_request(:get, 'https://api.github.com/user')
  .to_return(body:'{"id":42,"email":"alice@example.com"}',
             headers: { 'content-type' => 'application/json' })

WebMock.enable!
WebMock.allow_net_connect!
