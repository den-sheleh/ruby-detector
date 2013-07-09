module BundlerLockfile
  module ClassMethods
    def gemfile_lock?
      File.exist?('Gemfile') && File.exist?('Gemfile.lock')
    end

    def bundle
      @bundle ||= parse_bundle
    end

    def parse_bundle
      $:.unshift File.expand_path("../../vendor/bundler", __FILE__)
      require "bundler"
      Bundler::LockfileParser.new(File.read("Gemfile.lock"))
    end

    def gem_version(name)
      if gem = bundle.specs.detect {|g| g.name == name }
        gem.version
      end
    end
  end

  def bundle
    self.class.bundle
  end
end
