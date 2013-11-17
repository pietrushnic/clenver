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

    def help
      puts "this is help"
    end
  end
end
