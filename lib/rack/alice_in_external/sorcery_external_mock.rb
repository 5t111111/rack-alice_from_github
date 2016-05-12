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

module Rack
  # Stubbing authentication via Sorcery external
  #
  # Assume you have built the controller following to the below post:
  # https://github.com/NoamB/sorcery/wiki/External
  #
  # Requires a user has an associtation with authentications(uid: 42)
  module AliceInExternal
    class SorceryGithubExternalMock
      def initialize(app)
        @app = app
      end

      def call(env)
        if env['PATH_INFO'] =~ %r{\A.*oauth/github/?\z}
          return [301, { 'Location' => '/oauth/callback?provider=github' }, []]
        end
        @app.call(env)
      end
    end
  end
end
