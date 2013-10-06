require 'clenver/repository'
require 'clenver/link'

class Project
  def initialize(name, repos)
    @name = name
    @repos = repos
    @repo_list = nil
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
        puts "uri:#{uri}, content:#{content}"
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
        puts "uri:#{uri}, content:#{content}"
        begin
          unless content.nil?
            #links
            content['links'].each do |s,d|
              s_path = content['object'].get_abs_path + "/" + s
              Link.new(s_path,d).create
            end
          end
        rescue Exception => msg
          puts msg
        end
      end
    when String
      begin
        unless @respo.nil?
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
