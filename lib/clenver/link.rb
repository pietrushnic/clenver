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
      d = d.to_s.gsub(/\$\w+/) {|m| ENV[m[1..-1]]}
      logger.debug("d:#{d}")
      logger.debug("src:#{src.gsub(/\$\w+/) {|n| ENV[n[1..-1]]}}")
      while i < MAX_REPEAT do
        begin
          File.symlink(src.gsub(/\$\w+/) {|n| ENV[n[1..-1]]}, d)
        rescue SystemCallError
          FileUtils.mv(d, d + "_old")
        else
          logge.debug("else")
          break
        end
        i += 1
      end
    end
  end
end
