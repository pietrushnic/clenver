require 'fileutils'
require 'clenver/logging'

class Link
  include Logging
  MAX_REPEAT = 3
  attr_accessor :src, :dst
  def initialize(src,dst)
    @src = src
    @dst = dst
  end

  def create
    puts "Link.create"
    dst.each do |d|
      i = 0
      logger.debug("d:#{d}")
      logger.debug("src:#{src}")
      while i < MAX_REPEAT do
        begin
          File.symlink(src, d.to_s)
        rescue SystemCallError
          FileUtils.mv(d.to_s, d.to_s + "_old")
        else
          break
        end
        i += 1
      end
    end
  end
end
