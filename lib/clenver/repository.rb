require 'git'
require 'clenver/logging'

class Repository
  include Logging
  attr_accessor :repo_uri, :content, :repo, :dst
  def initialize(uri, content = nil, dst = Dir::pwd)
    @repo_uri = uri
    @dst = dst
    @abs_path = nil
    @repo = nil
    @content = content
  end

  def clone
    repo_basename = File.basename("#{repo_uri}",".git")
    repo = Git.clone(repo_uri, repo_basename)
    logger.debug("clone:#{repo}")
    @abs_path = Dir::pwd + "/" + repo_basename
  end

  def get_abs_path
    @abs_path
  end
  def add_remote(name, uri)
    logger.debug("self.inspect:#{self.inspect}")
    Git.open(@abs_path).add_remote(name, uri)
  end
end
