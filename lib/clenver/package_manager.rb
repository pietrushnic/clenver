class PackageManger
  attr_accessor :pkgs
  def initialize(name, pkgs)
    @name = name
    @pkgs = pkgs
  end

  def install()
    case @name
    when 'apt'
      out = %x[sudo apt-get -y install #{pkgs}]
    when 'gem'
      out = %x[gem install #{pkgs}]
    end
    puts out
  end

  def check(pkg)
  end
end
