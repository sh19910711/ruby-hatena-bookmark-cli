module HatenaBookmarkCLI
  require 'rack/csrf'
  require 'sinatra/base'
  require 'sinatra/contrib'
  require 'haml'
  require 'oauth'
  require 'json'
  require 'securerandom'

  require_relative 'version'
  require_relative 'store'
  require_relative 'config'

  class Server < Sinatra::Base
    configure :development do
      puts "### DEVELOPMENT MODE ###"
      register Sinatra::Reloader
    end

    configure do
      # session_secretを生成する
      @config = Config.load
      @config[:session_secret] ||= SecureRandom.hex[0...128]
      Config.save @config

      use Rack::Session::Cookie,
        :key => 'HATENA_BOOKMARK_TO_LINGR_SID',
        :secret => @config[:session_secret],
        :expire_after => 60 * 60 * 24 * 20
      use Rack::Csrf, :field => 'csrf_token'

      helpers do
        def csrf_token
          Rack::Csrf.csrf_token(env)
        end
        def csrf_tag
          Rack::Csrf.csrf_tag(env)
        end
      end
    end

    before do
      @config = Config.load
      @store  = Store.load
      @consumer_key     = @config[:consumer_key] || @config["consumer_key"]
      @consumer_secret  = @config[:consumer_secret] || @config["consumer_secret"]
    end

    after do
      Store.save @store
      Config.save @config
    end

    before do
      @consumer = OAuth::Consumer.new(
        @consumer_key,
        @consumer_secret,
        :site => 'https://www.hatena.ne.jp',
        :request_token_path => '/oauth/initiate',
        :authorize_path     => '/oauth/authorize',
        :access_token_path  => '/oauth/token',
      )
    end

    get "/" do
      haml :index
    end

    post "/update" do
      # タグリストを更新する
      access_token = OAuth::AccessToken.new(
        @consumer,
        @store[:oauth_token],
        @store[:oauth_token_secret],
      )

      # タグを取得する
      res = access_token.request(:get, 'http://b.hatena.ne.jp/1/my/tags')
      tags = JSON.parse(res.body)["tags"].map {|tag| tag["tag"]}
      # タグを記録する
      @store[:tags] = tags

      haml :ok
    end

    post "/login" do
      # OAuth認証
      oauth_callback_url = "http://#{@env["HTTP_HOST"]}/callback"
      request_token = @consumer.get_request_token(
        {
          :oauth_callback => oauth_callback_url
        },
        :scope => 'read_public,write_public'
      )
      @store[:request_token] = request_token.token
      @store[:request_token_secret] = request_token.secret
      redirect request_token.authorize_url
    end

    # OAuth認証が成功したとき
    get "/callback" do
      request_token = OAuth::RequestToken.new(
        @consumer,
        @store[:request_token],
        @store[:request_token_secret],
      )
      @store[:request_token] = nil
      @store[:request_token_secret] = nil

      oauth_token = request_token.get_access_token(
        {},
        :oauth_verifier => params[:oauth_verifier],
      )

      @store[:oauth_token] = oauth_token.token
      @store[:oauth_token_secret] = oauth_token.secret

      haml :ok
    end
  end
end
