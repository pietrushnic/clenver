require 'gli'
require 'clenver'
require 'clenver/project'
require 'clenver/logging'
require 'clenver/package_manager'

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
          unless yaml['apt'].nil?
            for pkg in yaml['apt'] do
              pkgs = pkg + " "
            end
            puts pkgs
            p_mgr = PackageManger.new('apt', pkgs)
            p_mgr.install()
          end
          unless yaml['gem'].nil?
            for pkg in yaml['gem'] do
              pkgs = pkg + " "
            end
            puts pkgs
            p_mgr = PackageManger.new('gem', pkgs)
            p_mgr.install()
          end
          p.create_repos
          p.init_project
        rescue Psych::SyntaxError => ex
          exit_now!("#{@path}: syntax error : #{ex.message}", 1)
        end
      else
        exit_now!("#{@path} no such file or directory", 2)
      end
    end
  end
end
