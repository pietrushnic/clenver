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
    @reps.each do |r|
      begin

      rescue Exception => msg
        puts msg
      end
  end
end
