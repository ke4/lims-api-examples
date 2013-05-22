# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "lims-api-examples"
  s.version     = "0.1" 
  s.authors     = ["Loic Le Henaff"]
  s.email       = ["llh1@sanger.ac.uk"]
  s.homepage    = ""
  s.summary     = %q{}
  s.description = %q{}

  s.rubyforge_project = "lims-api-examples"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['helpers', '1_order_2_tubes_manual_extraction']

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_dependency('rest-client')
  s.add_dependency('sequel')
  s.add_dependency('facets')

  #development
  s.add_development_dependency('rspec', '~> 2.8.0')
  s.add_development_dependency('yard', '>= 0.7.0')
  s.add_development_dependency('yard-rspec', '0.1')
  s.add_development_dependency('rake')
  s.add_development_dependency('sqlite3')
  s.add_development_dependency('mysql')
end
