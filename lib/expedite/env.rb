require 'digest'
require 'pathname'
require 'expedite/version'
require 'expedite/server/agent_manager'

module Expedite
  class Env
    attr_accessor :root
    attr_accessor :application_id, :app_name, :log_file
    attr_reader :applications

    def initialize(root: nil, app_name: nil, log_file: nil)
      @root = root || Dir.pwd
      @app_name = app_name || File.basename(@root)
      @log_file = log_file || File.open(File::NULL, "a")
      @tmp_path = nil

      @application_id = Digest::SHA1.hexdigest(@root)

      env = self
      @applications = Hash.new do |h, k|
        h[k] = Server::AgentManager.new(k, env)
      end
    end

    def version
      Expedite::VERSION
    end

    def tmp_path
      return @tmp_path unless @tmp_path.nil?

      require "tmpdir"
      path = Pathname.new(File.join(Dir.tmpdir, "expedite-#{Process.uid}"))
      require "fileutils"
      FileUtils.mkdir_p(path) unless path.exist?
      @tmp_path = path
    end

    def socket_path
      tmp_path.join(application_id)
    end

    def pidfile_path
      tmp_path.join("#{application_id}.pid")
    end

    def log(message)
      log_file.puts "[#{Time.now}] [#{Process.pid}] #{message}"
      log_file.flush
    end

    def server_command
      "#{File.expand_path("../../../bin/expedite", __FILE__)} server --background"
    end

    def graceful_termination_timeout
      2
    end

    def helper_path
      Pathname.new(root).join("expedite_helper.rb")
    end

    def load_helper
      path = helper_path
      if path.exist?
        log "loading #{path}"
        load(path)
      end
    end
  end
end
