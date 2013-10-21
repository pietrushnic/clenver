require 'clenver/repository'
require 'clenver/link'

class Project
  include Logging
  attr_accessor :name, :repos, :dst, :abs_path
  def initialize(name, repos, dst)
    @name = name
    @repos = repos
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

  def create_repos(dst=nil)
    logger.debug("create_repos:")
    goto_dst
    case @repos
    when Hash
      @repos.each do |uri, content|
        #TODO: verify if r is a supported repo
        begin
          r = Repository.new(uri, dst)
          r.clone
          @repos[uri]['object'] = r
        rescue Exception => msg
          puts msg
        end
      end
    when String
      begin
        repo = Repository.new(@repos, dst)
        repo.clone
      rescue Exception => msg
        puts msg
      end
    end
  end

  def init_project
    logger.debug("init_project:")
    case @repos
    when Hash
      init_links
      init_repos
      init_runs
    when String
      begin
        unless @repos.nil?
          @repos['links'].each do |s,d|
            Link.new(s,d).create
          end
        end
      rescue Exception => msg
        puts msg
      end
    end
  end

  def init_links
    @repos.each do |uri, content|
      begin
        unless content.nil?
          #links
          unless content['links'].nil?
            content['links'].each do |s,d|
              if /\$\w+/.match(s)
                #TODO: this is ugly and should be fixed
                buf = Array.new().push(s)
                s_path = Link.new(s,d).expand_dst(buf)[0]
              elsif
                s_path = content['object'].get_abs_path + "/" + s
              end
              Link.new(s_path,d).create
            end
          end
        end
      rescue Exception => msg
        puts msg
      end
    end
  end

  def init_repos
    @repos.each do |uri, content|
      begin
        unless content.nil?
          #remotes
          unless content['remotes'].nil?
            content['remotes'].each do |name, uri|
              Dir::chdir(content['object'].get_abs_path)
              content['object'].add_remote(name, uri)
            end
          end
        end
      rescue Exception => msg
        puts msg
      end
    end
  end

  def init_runs
    @repos.each do |uri, content|
      begin
        unless content.nil?
          #run
          unless content['run'].nil?
            content['run'].each do |cmd|
              Dir::chdir(content['object'].get_abs_path)
              puts %x[#{cmd}]
            end
          end
        end
      rescue Exception => msg
        puts msg
      end
    end
  end
end
