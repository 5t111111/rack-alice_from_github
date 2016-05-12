module Rack
  module AliceInExternal
    class GithubMock
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
