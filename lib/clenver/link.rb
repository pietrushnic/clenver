class Link
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

      File.symlink(@src, d.to_s)
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
