require 'git'
require 'clenver/logging'

class Repository
  include Logging
  attr_accessor :repo_uri, :config, :repo, :dst, :remotes
  #TODO: think about better way to handle dst from URI
  def initialize(uri, config = nil)
    @repo_uri = uri
    @dst = get_dst(config)
    @remotes = get_remotes(config)
    @abs_path = nil
    @repo = nil
  end

  def get_remotes(config)
    unless config.nil?
      if config.has_key?('remotes')
        config['remotes']
      end
    end
  end

  def get_dst(config)
    unless config.nil?
      if config.has_key?('dst')
        return config['dst'][0]
      end
    end
    logger.debug("dst:#{Dir::pwd + "/" + File.basename(repo_uri, '.git')}")
    Dir::pwd + "/" + File.basename(repo_uri, '.git')
  end

  def clone
    repo = Git.clone(repo_uri, dst)
    logger.debug("clone:#{repo}")
  end

  def get_abs_path
    @abs_path
  end

  def add_remotes
    logger.debug("self.inspect:#{self.inspect}")
    unless remotes.nil?
      for name, uri in remotes do
        Git.open(dst).add_remote(name, uri)
      end
    end
  end
end
