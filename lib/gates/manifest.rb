# frozen_string_literal: true

module Gates
  class Manifest
    attr_accessor :version_map

    def initialize(manifest_hash)
      versions = []
      # iterate backward through the versions to be able to associate the
      # predecessor with each
      manifest_hash['versions'].sort_by { |version| version['id'] }
                               .each do |version_data|
        api_version = ApiVersion.new(
          version_data['id'],
          version_data['gates'],
          version_data['actions'],
          versions.last
        )
        puts version_data['request']
        versions << api_version
        puts versions.last
      end

      self.version_map = {}
      versions.each do |version|
        version_map[version.id] = version
      end
    end

    def [](version_id)
      version_map[version_id]
    end
  end
end