# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','clenver','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'clenver'
  s.version = Clenver::VERSION
  s.author = 'Piotr Król'
  s.email = 'pietrushnic@gmail.com'
  s.homepage = 'https://github.com/pietrushnic/clenver'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Command line home directory manager'
  s.license = 'GPLv2'
  s.description = 'clenver aims to shorten time of configuring your brand new *NIX account to fully featured development envionment of your choice'
# Add your other files here if you make them
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','clenver.rdoc']
  s.rdoc_options << '--title' << 'clenver' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'clenver'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_development_dependency('rspec-expectations')
  s.add_runtime_dependency('gli','2.8.0')
  s.add_runtime_dependency('thor','0.18.1')
  s.add_runtime_dependency('git','1.2.6')
end
