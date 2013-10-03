require 'git'

class Repository
  def initialize(repo, dst)
    @repo_uri = repo[0]
    @attr = repo[1]
    @dst = dst
  end

  def clone
    Git.clone(@repo_uri, File.basename("#{@repo_uri}",".git"))
  end
end
