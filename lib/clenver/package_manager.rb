class PackageManger
  def initialize(name, pkgs)
    @name = name
    @pkgs = pkgs
  end

  def install()
    case @name
    when 'apt'
      out = %x[sudo apt-get install #{@pkgs}]
    when 'gem'
      out = %x[gem install #{@pkgs}]
    end
    puts out
  end

  def check(pkg)
  end
end
