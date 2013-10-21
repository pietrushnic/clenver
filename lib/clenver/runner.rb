require 'gli'
require 'clenver/project'
require 'clenver/logging'

module Clenver
  class Runner
    include Logging

    def initialize(path, dst)
      @path = path
      @dst = dst
    end

    def start
      if File.exist?(@path)
        begin
          yaml = Psych.load_file("#{@path}")
          logger.debug("yaml: #{yaml}")
          #TODO: create test and fix this place with check for empty file
          p = Project.new(File.basename("#{@path}", ".yml"), yaml, @dst)
          p.create_repos
          p.init_repos
        rescue Psych::SyntaxError => ex
          exit_now!("#{@path}: syntax error : #{ex.message}", 1)
        end
      else
        exit_now!("#{@path} no such file or directory", 2)
      end
    end
  end
end
