require 'psych'
require 'clenver'
require 'clenver/project'
require 'clenver/logging'
require 'clenver/package_manager'

module Clenver
  class Runner
    include Logging

    attr_accessor :path, :dst, :yaml
    def initialize(path, dst)
      @path = path
      @dst = dst
      @yaml = parse_config
    end

    def parse_config
      begin
        Psych.load_file("#{path}")
      rescue Psych::SyntaxError => ex
        logger.error("#{path}: syntax error : #{ex.message}")
        exit 1
      end
    end

    def create_package_manager(type)
      PackageManger.new(type, yaml[type].join(' '))
    end

    def create_repository(uri)
      logger.debug("content:#{yaml[uri]}")
      if yaml[uri].is_a?(Hash)
        Repository.new(uri, yaml[uri])
      else
        Repository.new(uri)
      end
    end

    def start
      #TODO: create test and fix this place with check for empty file
      p = Project.new(File.basename("#{path}", ".yml"), yaml, dst)
      if yaml.is_a?(Hash)
        for k,v in yaml do
          logger.info("key:#{k}")
          logger.info("value:#{v}")
          if k == 'apt' or k == 'gem'
            p.pkg_mgr << create_package_manager(k)
          end
          if k.match /(http|https|git).+/
            p.repos << create_repository(k)
            logger.debug("p.repos:#{p.repos}")
            logger.debug("p.repos[0].content:#{p.repos[0].content}")
          end
        end
      else
        logger.error("#{path} is not a valid clenver configuration")
        exit 2
      end
      p.init
      p.init_project
    end
  end
end
