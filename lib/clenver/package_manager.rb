class PackageManger
  def initialize(name, pkgs)
    @name = name
    @pkgs = pkgs
  end

  def install()
    out = %x[sudo apt-get install #{@pkgs}]
    puts out
  end

  def check(pkg)
  end
end
