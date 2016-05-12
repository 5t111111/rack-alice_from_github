require 'webmock'

module Rack
  module AliceInExternal
    class GithubMock
      include WebMock::API

      def initialize(app)
        stub_external_requests!
        @app = app
      end

      def call(env)
        if env['PATH_INFO'] =~ %r{\A.*/oauth/github/?\z}
          return [301, { 'Location' => '/oauth/callback?provider=github' }, []]
        end
        @app.call(env)
      end

      private

      def stub_external_requests!
        # Stubbing external request for GitHub OAuth via WebMock
        stub_request(:post, 'https://github.com/login/oauth/access_token')
        .to_return(body: 'access_token=charleslutwidgedodgson&scope=user%2Cgist&token_type=bearer',
                   headers: { 'content-type' => 'application/x-www-form-urlencoded' })

        stub_request(:get, 'https://api.github.com/user')
        .to_return(body: user_info,
                   headers: { 'content-type' => 'application/json' })

        WebMock.enable!
        WebMock.allow_net_connect!
      end

      def user_info
        <<-JSON
{
  "login": "alice",
  "id": 42,
  "avatar_url": "https://avatars.githubusercontent.com/u/42?v=3",
  "gravatar_id": "",
  "url": "https://api.github.com/users/alice",
  "html_url": "https://github.com/alice",
  "followers_url": "https://api.github.com/users/alice/followers",
  "following_url": "https://api.github.com/users/alice/following{/other_user}",
  "gists_url": "https://api.github.com/users/alice/gists{/gist_id}",
  "starred_url": "https://api.github.com/users/alice/starred{/owner}{/repo}",
  "subscriptions_url": "https://api.github.com/users/alice/subscriptions",
  "organizations_url": "https://api.github.com/users/alice/orgs",
  "repos_url": "https://api.github.com/users/alice/repos",
  "events_url": "https://api.github.com/users/alice/events{/privacy}",
  "received_events_url": "https://api.github.com/users/alice/received_events",
  "type": "User",
  "site_admin": false,
  "name": "Alice Liddell",
  "company": null,
  "blog": "http://alice-in-wonderland.example.com",
  "location": "Wonderland",
  "email": "alice@example.com",
  "hireable": null,
  "bio": null,
  "public_repos": 10,
  "public_gists": 20,
  "followers": 30,
  "following": 40,
  "created_at": "2010-07-15T16:14:02Z",
  "updated_at": "2016-05-12T10:08:11Z"
}
        JSON
      end
    end
  end
end

