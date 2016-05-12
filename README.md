# Rack::AliceInExternal

Rack::AliceInExternal is a Rack middleware which provides rough and dirty stubbing for authentication via [Sorcery](https://github.com/NoamB/sorcery) external (GitHub OAuth only for the moment).

Assumes that you have built the `OauthsController` following to https://github.com/NoamB/sorcery/wiki/External :

```ruby
class OauthsController < ApplicationController

  ...

  def oauth

    ...

  end

  def callback

    ...

  end

  ...

end
```

Rack::AliceInExternal hooks requests for `/oauth/[provider]` and returns the stubbed response which redirects you to `/oauth/callback?provider=[provider]`.

Then `callback` action tries to acquire the access token for authentication from the provider, Rack::AliceInExternal stubs those requests via [WebMock](https://github.com/bblimke/webmock) and returns the response of the access token and the user data that can be appropriately handled by Sorcery.

This helps you to write feature tests in more user-story-friendly ways, like:

```ruby
visit root_url
click_link 'Login with GitHub'
...
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-alice_in_external'
```

## Usage

Rack::AliceInExternal tries to find the user who has an association with `uid: 42` in `authentications` table, so you have to create that user and the authentication associated to her (and you cannot change `uid` other than `42`) .

Fixture examples:

__users.yml__

```yaml
alice:
  name: Alice
```

__authentications.yml__


```yaml
alice_auth:
  uid: 42
  provider: github
  user: alice
```

Add the middleware you want to use for stubbing in `config/environments/test.rb` (add it in `development.rb` as well if necessary):

```ruby
Rails.application.configure do

  ...


  # Stubbing OAuth authentication via Sorcery's GitHub external
  config.middleware.use Rack::AliceInExternal::GithubMock

  ...

end
```

Then just write feature tests like the below, it tries to login as the user with `uid: 42`:

```ruby
visit root_url
click_link 'Login with GitHub' # <= the link to /oauth/[provider]

...

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/5t111111/rack-alice_in_external.

