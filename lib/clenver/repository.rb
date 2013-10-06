require 'git'

class Repository
  def initialize(repo, dst)
    @repo_uri = repo
    @dst = dst
    @abs_path = nil
    @repo = nil
  end

  def clone
    repo_basename = File.basename("#{@repo_uri}",".git")
    @repo = Git.clone(@repo_uri, repo_basename)
    @abs_path = Dir::pwd + "/" + repo_basename
  end

  def get_abs_path
    @abs_path
  end
  def add_remote(name, uri)
    @repo.add_remote(name, uri)
  end
end
