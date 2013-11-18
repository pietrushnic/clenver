require 'clenver/repository'
require 'clenver/link'
require 'clenver/logging'

class Project
  include Logging
  attr_accessor :name, :repos, :dst, :abs_path, :pkg_mgr, :yaml
  def initialize(name, yaml, dst)
    @name = name
    @yaml = yaml
    @repos = []
    @pkg_mgr = []
    @dst = dst
    @abs_path = Dir::pwd + "/" + @name
  end

  def goto_dst
    if @dst
      path = @abs_path + "/../" + @dst + "/" + @name
      FileUtils.mkdir_p(path)
    else
      path = @abs_path
      Dir::mkdir(path)
    end
    Dir::chdir(path)
  end

  def init
    for r in repos do
      logger.debug("repo:#{r.repo_uri}")
      r.clone
    end
    for p in pkg_mgr do
      p.install
    end
  end

  def init_project
    logger.debug("init_project:")
    case @yaml
    when Hash
      init_links
      init_repos
      init_runs
    when String
      begin
        unless @yaml.nil?
          @yaml['links'].each do |s,d|
            Link.new(s,d).create
          end
        end
      rescue Exception => msg
        puts msg
      end
    end
  end

  def init_links
    logger.debug("init_links")
    @yaml.each do |uri, content|
      if content.is_a?(Hash)
        #links
        unless content['links'].nil?
          content['links'].each do |s,d|
            #TODO: this is ugly and should be fixed
            buf = Array.new().push(s)
            s_path = Link.new(s,d).expand_dst(buf)[0]
            Link.new(s_path,d).create
          end
        end
      end
    end
  end

  def init_repos
    logger.debug("init_yaml")
    repos.each do |r|
      logger.debug("r:#{r}")
      if r.content.is_a?(Hash)
        #remotes
        logger.debug("content:#{r.content}")
        unless r.content['remotes'].nil?
          logger.debug("r.content:#{r.content['remotes']}")
          r.content['remotes'].each do |name, uri|
            r.add_remote(name, uri)
          end
        end
      end
    end
  end

  def init_runs
    logger.debug("init_runs")
    @yaml.each do |uri, content|
      if content.is_a?(Hash)
        #run
        unless content['run'].nil?
          content['run'].each do |cmd|
            puts %x[#{cmd}]
          end
        end
      end
    end
  end
end
