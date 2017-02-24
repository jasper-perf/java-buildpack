# -*- encoding: utf-8 -*-
# stub: buildpack-packager 2.3.6 ruby lib

Gem::Specification.new do |s|
  s.name = "buildpack-packager"
  s.version = "2.3.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Cloud Foundry Buildpacks Team"]
  s.date = "2017-02-27"
  s.description = "Tool that packages your Cloud Foundry buildpacks based on a manifest"
  s.email = ["cf-buildpacks-eng@pivotal.io"]
  s.executables = ["buildpack-packager"]
  s.files = [".gitignore", ".rspec", "Gemfile", "LICENSE", "NOTICE", "README.md", "Rakefile", "bin/buildpack-packager", "buildpack-packager.gemspec", "doc/disconnected_environments.md", "lib/buildpack/manifest_dependency.rb", "lib/buildpack/manifest_validator.rb", "lib/buildpack/packager.rb", "lib/buildpack/packager/default_versions_presenter.rb", "lib/buildpack/packager/dependencies_presenter.rb", "lib/buildpack/packager/manifest_schema.yml", "lib/buildpack/packager/package.rb", "lib/buildpack/packager/table_presentation.rb", "lib/buildpack/packager/version.rb", "lib/buildpack/packager/zip_file_excluder.rb", "lib/kwalify/parser/yaml-patcher.rb", "spec/buildpack/packager_spec.rb", "spec/fixtures/buildpack-with-uri-credentials/VERSION", "spec/fixtures/buildpack-with-uri-credentials/manifest.yml", "spec/fixtures/buildpack-without-uri-credentials/VERSION", "spec/fixtures/buildpack-without-uri-credentials/manifest.yml", "spec/fixtures/manifests/manifest_invalid-md6.yml", "spec/fixtures/manifests/manifest_invalid-md6_and_defaults.yml", "spec/fixtures/manifests/manifest_valid.yml", "spec/fixtures/manifests/manifest_valid_plus_deprecation_dates.yml", "spec/helpers/cache_directory_helpers.rb", "spec/helpers/fake_binary_hosting_helpers.rb", "spec/helpers/file_system_helpers.rb", "spec/integration/bin/buildpack_packager/download_caching_spec.rb", "spec/integration/bin/buildpack_packager_spec.rb", "spec/integration/buildpack/directory_name_spec.rb", "spec/integration/buildpack/packager_spec.rb", "spec/integration/default_versions_spec.rb", "spec/integration/output_spec.rb", "spec/spec_helper.rb", "spec/unit/buildpack/packager/zip_file_excluder_spec.rb", "spec/unit/manifest_dependency_spec.rb", "spec/unit/manifest_validator_spec.rb", "spec/unit/packager/package_spec.rb"]
  s.homepage = "https://github.com/cloudfoundry/buildpack-packager"
  s.licenses = ["Apache-2.0"]
  s.required_ruby_version = Gem::Requirement.new("~> 2.2")
  s.rubygems_version = "2.5.1"
  s.summary = "Tool that packages your buildpacks based on a manifest"
  s.test_files = ["spec/buildpack/packager_spec.rb", "spec/fixtures/buildpack-with-uri-credentials/VERSION", "spec/fixtures/buildpack-with-uri-credentials/manifest.yml", "spec/fixtures/buildpack-without-uri-credentials/VERSION", "spec/fixtures/buildpack-without-uri-credentials/manifest.yml", "spec/fixtures/manifests/manifest_invalid-md6.yml", "spec/fixtures/manifests/manifest_invalid-md6_and_defaults.yml", "spec/fixtures/manifests/manifest_valid.yml", "spec/fixtures/manifests/manifest_valid_plus_deprecation_dates.yml", "spec/helpers/cache_directory_helpers.rb", "spec/helpers/fake_binary_hosting_helpers.rb", "spec/helpers/file_system_helpers.rb", "spec/integration/bin/buildpack_packager/download_caching_spec.rb", "spec/integration/bin/buildpack_packager_spec.rb", "spec/integration/buildpack/directory_name_spec.rb", "spec/integration/buildpack/packager_spec.rb", "spec/integration/default_versions_spec.rb", "spec/integration/output_spec.rb", "spec/spec_helper.rb", "spec/unit/buildpack/packager/zip_file_excluder_spec.rb", "spec/unit/manifest_dependency_spec.rb", "spec/unit/manifest_validator_spec.rb", "spec/unit/packager/package_spec.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["~> 4.1"])
      s.add_runtime_dependency(%q<kwalify>, ["~> 0"])
      s.add_runtime_dependency(%q<terminal-table>, ["~> 1.4"])
      s.add_development_dependency(%q<bundler>, ["~> 1.7"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.5"])
      s.add_development_dependency(%q<rubyzip>, ["~> 1.2"])
      s.add_development_dependency(%q<rubocop>, ["~> 0"])
      s.add_development_dependency(%q<rubocop-rspec>, ["~> 1.5"])
    else
      s.add_dependency(%q<activesupport>, ["~> 4.1"])
      s.add_dependency(%q<kwalify>, ["~> 0"])
      s.add_dependency(%q<terminal-table>, ["~> 1.4"])
      s.add_dependency(%q<bundler>, ["~> 1.7"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<rspec>, ["~> 3.5"])
      s.add_dependency(%q<rubyzip>, ["~> 1.2"])
      s.add_dependency(%q<rubocop>, ["~> 0"])
      s.add_dependency(%q<rubocop-rspec>, ["~> 1.5"])
    end
  else
    s.add_dependency(%q<activesupport>, ["~> 4.1"])
    s.add_dependency(%q<kwalify>, ["~> 0"])
    s.add_dependency(%q<terminal-table>, ["~> 1.4"])
    s.add_dependency(%q<bundler>, ["~> 1.7"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<rspec>, ["~> 3.5"])
    s.add_dependency(%q<rubyzip>, ["~> 1.2"])
    s.add_dependency(%q<rubocop>, ["~> 0"])
    s.add_dependency(%q<rubocop-rspec>, ["~> 1.5"])
  end
end
