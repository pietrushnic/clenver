require 'clenver'
require 'clenver/runner'
require 'clenver/logging'
require 'thor'
require 'thor/actions'

module Clenver
  class CLI < Thor
    include Thor::Actions
    include Logging
    def self.start(*)
      super
      # logger.debug("args: #{args}")
      # path = args[0]
      # dst_dist = args[1]
      # Clenver::Runner.new(path, dst_dist).start
    end

    def initialize(*)
      super
    end

    default_task :help

    def help(cli = nil)
      logger.error("Not implemented")
    end

    desc "init [FILE]", "initialize $HOME directory according to instructions in FILE"
    def init(config, dst = nil)
      if File.exist?(config)
        Clenver::Runner.new(config, dst).start
      else
        exit 2
      end
    end

    desc "version", "Prints the clenver's version information" 
    def version
      logger.info("Clenver version #{Clenver::VERSION}")
    end
  end
end
