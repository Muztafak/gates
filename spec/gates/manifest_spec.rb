# frozen_string_literal: true

require 'spec_helper'

describe Gates::Manifest do
  describe '#initialize' do
    let(:manifest_data) do
      {
        'versions' => [
          {
            'id' => '2020-01-01',
            'gates' => [
              'name' => 'allows_bar'
            ]
          },
          {
            'id' => '2020-06-01',
            'gates' => [
              'name' => 'allows_foo'
            ]
          }
        ]
      }
    end

    let(:manifest) { Gates::Manifest.new(manifest_data) }

    it 'fills the version_map' do
      expect(manifest.version_map.size).to eq 2
    end

    it 'sets the api version gates' do
      verison = manifest.version_map['2020-01-01']
      expect(verison.gates.size).to eq 1
    end

    it 'calculates the version predecessor' do
      earlier_version = manifest.version_map['2020-06-01'].predecessor
      expect(earlier_version.id).to eq '2020-01-01'
    end


  end

  describe '#[]'
end