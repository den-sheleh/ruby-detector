require 'bundler_lockfile'

class RubyDetector
  include BundlerLockfile
  extend BundlerLockfile::ClassMethods

  class << self
    def detect(path)
      Dir.chdir(path)

      %w(rails3 rails2 rack ruby).detect do |pack_name|
        send("#{pack_name}_use?") ? pack_name : false
      end
    end

    private

    def rails3_use?
      if gemfile_lock?
        rails_version = gem_version('railties')
        rails_version >= Gem::Version.new('3.0.0') && rails_version < Gem::Version.new('4.0.0') if rails_version
      end
    end

    def rails2_use?
      if gemfile_lock?
        rails_version = gem_version('rails')
        rails_version >= Gem::Version.new('2.0.0') && rails_version < Gem::Version.new('3.0.0') if rails_version
      end
    end

    def rack_use?
      gemfile_lock? && gem_version('rack')
    end

    def ruby_use?
      File.exist?("Gemfile")
    end
  end
end