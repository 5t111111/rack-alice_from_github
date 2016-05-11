module Rack
  module AliceFromGithub
    # Stubbing logging-in via GitHub OAuth for Sorcery external
    # https://github.com/NoamB/sorcery/wiki/External
    # Requires a user named 'Alice'
    class SorceryGithubExternalMock
      def initialize(app)
        @app = app
      end

      def call(env)
        if env['PATH_INFO'] =~ %r{\A.*oauth/github/?\z}
          return [301, { 'Location' => '/oauth/callback' }, []]
        end

        if env['PATH_INFO'] =~ %r{\A.*/oauth/callback/?\z}
          req = Rack::Request.new(env)
          req.session[:user_id] = User.find_by(name: 'Alice').id.to_s
          return [301, { 'Location' => '/' }, []]
        end

        @app.call(env)
      end
    end
  end
end
