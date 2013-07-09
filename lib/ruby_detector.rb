class RubyDetector
  class << self
    def detect(path)
      Dir.chdir(path)

      %w(rails3 rails2 rack ruby).detect do |pack_name|
        send("#{pack_name}_use?") ? pack_name : false
      end
    end

    private

    def rails3_use?
      rails2_use? &&
        File.exists?("config/application.rb") &&
        File.read("config/application.rb") =~ /Rails::Application/
    end

    def rails2_use?
      ruby_use? && File.exist?("config/environment.rb")
    end

    def rack_use?
      ruby_use? && File.exist?("config.ru")
    end

    def ruby_use?
      File.exist?("Gemfile")
    end
  end
end