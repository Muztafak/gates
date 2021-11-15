# frozen_string_literal: true

require 'yaml'

require 'gates/api_version'
require 'gates/gate'
require 'gates/manifest'
require 'gates/version'
require 'actions/params'
require 'actions/action'
# '/home/mustafak/Development/EnviaYa/enviaya_versioning/travis.yml'
# Gates.load '/home/mustafak/Development/EnviaYa/enviaya_versioning/api/versioning_manifest.yml'
module Gates
  Error = Class.new(StandardError)
  UninitializedError = Class.new(Gates::Error)

  class << self
    attr_accessor :manifest, :last_version

    def load(file_path)
      hash = case
             when File.directory?(file_path)
               {
                 'versions' => Dir.glob("#{file_path}/**/*.yml").map do |file|
                   Psych.load_file(file)['version']
                 end.compact
               }
             when File.file?(file_path) then Psych.load_file(file_path)
             else raise UninitializedError
        end
      @manifest = Manifest.new(hash)
      @last_version = Gates.manifest.version_map.keys.last
    end

    def for(version_id)
      raise UninitializedError unless @manifest

      @manifest[version_id]
    end
  end
end
