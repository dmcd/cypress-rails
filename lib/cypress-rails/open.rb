require_relative "finds_bin"
require_relative "starts_rails_server"

module CypressRails
  class Open
    def initialize
      @starts_rails_server = StartsRailsServer.new
      @finds_bin = FindsBin.new
    end

    def call(dir: Dir.pwd, port: ENV["RAILS_CYPRESS_PORT"], opts: ENV["CYPRESS_OPTS"])
      @starts_rails_server.call(dir: dir, port: port)
      bin = @finds_bin.call(dir)

      system <<~EXEC
        CYPRESS_BASE_URL=http://#{Capybara.server_host}:#{Capybara.server_port} #{bin} open --project "#{dir}" #{opts}
      EXEC
    end
  end
end
