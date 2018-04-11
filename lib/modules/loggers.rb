require 'logger'
# require_relative '../../config/environment.rb'
module Modules
  class Loggers
    def self.debug(path, message)
      ::Logger.new(make_log_file(path), 'daily').debug(message)
    end

    def self.error(path, message)
      ::Logger.new(make_log_file(path), 'daily').error(message)
    end

    def self.info(path, message)
      ::Logger.new(make_log_file(path), 'daily').info(message)
    end

    def self.warn(path, message)
      ::Logger.new(make_log_file(path), 'daily').warn(message)
    end

    def self.raw_log(path, message)
      full_path = make_log_file(path)
      File.open(full_path, 'a+') { |f| f.puts("R, [#{DateTime.now.as_json}]  RAW -- : " + message) }
    end

    private

    def self.make_log_file(path)
      log_address = "#{Rails.root}#{path}"
      make_dir(File.dirname(log_address))
      make_file(log_address)
      log_address
    end

    def self.make_dir(path)
      FileUtils.mkpath path unless File.directory? path
    end

    def self.make_file(path_to_file)
      FileUtils.touch path_to_file unless File.exist? path_to_file
    end
  end
end
