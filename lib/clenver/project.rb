require 'clenver/repository'

class Project
  def initialize(name, repos)
    @name = name
    @repos = repos
    @repo_list = nil
  end

  def create_repos(dst=nil)
    puts @repos
    @repos.each do |r|
      begin
        if dst
          path = dst + "/" + @name
          FileUtils.mkdir_p(path)
        else
          path = @name
          Dir::mkdir(path)
        end
        Dir::chdir(path)
        repo = Repository.new(r, dst)
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
