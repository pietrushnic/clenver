require 'clenver/repository'
require 'clenver/link'

class Project
  def initialize(name, repos)
    @name = name
    @repos = repos
    @abs_path = Dir::pwd + "/" + @name
  end

  def get_abs_path
    @abs_path
  end

  def create_repos(dst=nil)
    puts "create_repos:"
    if dst
      path = self.get_abs_path + "/../" + dst.to_s + "/" + @name
      puts path
      FileUtils.mkdir_p(path)
    else
      path = get_abs_path
      Dir::mkdir(path)
    end
    Dir::chdir(path)
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

  def init_repos
    puts "init_repos"
    case @repos
    when Hash
      @repos.each do |uri, content|
        begin
          unless content.nil?
            #links
            unless content['links'].nil?
              content['links'].each do |s,d|
                s_path = content['object'].get_abs_path + "/" + s
                Link.new(s_path,d).create
              end
            end
            #remotes
            unless content['remotes'].nil?
              content['remotes'].each do |name, uri|
                Dir::chdir(content['object'].get_abs_path)
                content['object'].add_remote(name, uri)
              end
            end
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
end
