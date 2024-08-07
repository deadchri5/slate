# -*- encoding: utf-8 -*-
# stub: padrino-helpers 0.15.2 ruby lib

Gem::Specification.new do |s|
  s.name = "padrino-helpers".freeze
  s.version = "0.15.2".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Padrino Team".freeze, "Nathan Esquenazi".freeze, "Davide D'Agostino".freeze, "Arthur Chiu".freeze]
  s.date = "2022-12-23"
  s.description = "Tag helpers, asset helpers, form helpers, form builders and many more helpers for padrino".freeze
  s.email = "padrinorb@gmail.com".freeze
  s.extra_rdoc_files = ["README.rdoc".freeze]
  s.files = ["README.rdoc".freeze]
  s.homepage = "http://www.padrinorb.com".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.rubygems_version = "3.0.8".freeze
  s.summary = "Helpers for padrino".freeze

  s.installed_by_version = "3.5.11".freeze if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<padrino-support>.freeze, ["= 0.15.2".freeze])
  s.add_runtime_dependency(%q<tilt>.freeze, [">= 1.4.1".freeze, "< 3".freeze])
  s.add_runtime_dependency(%q<i18n>.freeze, [">= 0.6.7".freeze, "< 2".freeze])
end
