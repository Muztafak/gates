# frozen_string_literal: true

require 'spec_helper'

describe Gates do
  it 'has a version number' do
    expect(Gates::VERSION).not_to be nil
  end

  describe '.for' do
    let(:manifest_data) do
      {
        'versions' => [
          {
            'id' => '2016-01-30',
            'gates' => [
              'name' => 'allows_special'
            ]
          }
        ]
      }
    end
    let(:manifest) { Gates::Manifest.new(manifest_data) }

    it 'returns Gates::ApiVersion' do
      Gates.manifest = manifest
      expect(Gates.for('2016-01-30')).to be_a(Gates::ApiVersion)
    end

    it 'returns nil if no api version exists' do
      Gates.manifest = manifest
      expect(Gates.for('hakuna matata')).to be_nil
    end

    it 'raises Gates::UninitializedError on uninitialized' do
      Gates.manifest = nil
      expect { Gates.for('some_version') }.to raise_error(Gates::UninitializedError)
    end
  end

  describe '#load' do
    context 'from single file' do
      let(:manifest) do
        Gates.load(File.join( Dir.pwd, 'api', 'versioning_manifest.yml'))
        Gates.manifest
      end

      it 'fills the version_map' do
        expect(manifest.version_map.size).to eq(2)
      end

      it 'sets the api version gates' do
        version = manifest.version_map['2020-01-01']
        expect(version.gates.size).to eq(2)
      end

      it 'calculates the version predecessor' do
        earlier_version = manifest.version_map['2020-06-01'].predecessor
        expect(earlier_version.id).to eq '2020-01-01'
      end
    end

    context 'load from DIR' do
      let(:manifest) do
        Gates.load(File.join( Dir.pwd, 'api'))
        Gates.manifest
      end

      it 'fills the version_map' do
        expect(manifest.version_map.size).to eq(2)
      end

      it 'sets the api version gates' do
        version = manifest.version_map['2020-01-01']
        expect(version.gates.size).to eq(2)
      end

      it 'calculates the version predecessor' do
        earlier_version = manifest.version_map['2020-06-01'].predecessor
        expect(earlier_version.id).to eq('2020-01-01')
      end
    end
  end
end
