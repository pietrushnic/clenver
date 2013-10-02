require 'clenver/repository'

class Project
  def initialize(name, repos)
    @name = name
    @repos = repos
    @repo_list = nil
  end

  def create_repos
    puts @repos
    @repos.each do |r|
      begin
        repo = Repository.new(r)
        repo.clone
      rescue Exception => msg
        puts msg
      end
    end
  end
end
