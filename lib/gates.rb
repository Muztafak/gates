# frozen_string_literal: true

require 'yaml'

require 'gates/api_version'
require 'gates/gate'
require 'gates/manifest'
require 'gates/version'
require 'gates/params'
# '/home/mustafak/Development/EnviaYa/enviaya_versioning/travis.yml'
# Gates.load '/home/mustafak/Development/EnviaYa/enviaya_versioning/api/versioning_manifest.yml'
module Gates
  Error = Class.new(StandardError)
  UninitializedError = Class.new(Gates::Error)

  class << self
    attr_accessor :manifest

    def load(file_path)
      hash = case
             when File.directory?(file_path)
               {
                 'versions' => Dir.glob("#{file_path}/**/*.yml").map do |file|
                   Psych.load_file(file)['version']
                 end.compact
               }
             when File.file?(file_path) then Psych.load_file(file_path)
        end
      @manifest = Manifest.new(hash)
    end

    def for(version_id)
      raise UninitializedError unless @manifest

      @manifest[version_id]
    end
  end
end
