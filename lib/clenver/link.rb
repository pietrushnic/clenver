require 'fileutils'

class Link
  MAX_REPEAT = 3
  def initialize(src,dst)
    @src = src
    @dst = expand_dst(dst)
  end
  def create
    puts "Link.create"
    puts @dst
    @dst.each do |d|
      puts "src:#{@src}"
      puts "d:#{d} "
      i = 0
      while i < MAX_REPEAT do
        begin
          File.symlink(@src, d.to_s)
        rescue SystemCallError => e
          FileUtils.mv(d.to_s, d.to_s + "_old")
        else
          break
        end
        i += 1
      end
    end
  end
  def expand_dst(dst)
    ret = Array.new()
    dst.each do |d|
      path = %x[ echo #{d}]
      ret.push(path.strip)
    end
    return ret
  end
end
