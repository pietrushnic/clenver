require 'clenver/logging'

class CommandExecutor
  include Logging
  attr_accessor :cmd
  def initialize(cmd)
    @cmd = cmd
  end

  def execute
    logger.info(%x[#{cmd}])
  end
end

