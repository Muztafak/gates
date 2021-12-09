# frozen_string_literal: true

module Gates
  class Manifest
    attr_accessor :version_map

    def initialize(manifest_hash)
      versions = []
      # iterate backward through the versions to be able to associate the
      # predecessor with each
      arranged_versions = manifest_hash['versions'].group_by { |aaa| aaa['id'] }
      arranged_versions = arranged_versions.map do |k,v|
        { 'id' => k, 'gates' => (v.map { |raw_version| raw_version['gates'] }).flatten(1), 'actions' => (v.map { |raw_version| raw_version['actions'] }).flatten(1) }
      end
      arranged_versions = arranged_versions.sort_by { |version| version['id'] }
      arranged_versions.each do |version_data|
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