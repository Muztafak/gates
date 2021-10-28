require 'spec_helper'

require 'spec_helper'

describe Gates::ApiVersion do
  describe '#enabled?' do
    let(:initial_version) do
      gate = { 'name' => 'allows_foo', 'description' => 'test description' }
      api_version = Gates::ApiVersion.new(
        '2016-01-29',
        [gate],
        { 'allowed' => ['req1', 'req2', 'req3'], 'deprecated' => ['reqa', 'reqb'] },
        { 'allowed' => ['res1', 'res2', 'res3'], 'deprecated' => ['resa', 'resb'] },
        nil
      )
      api_version
    end
    let(:later_version) do
      gate = { 'name' => 'allows_bar', 'description' => 'another description' }
      api_version = Gates::ApiVersion.new(
        '2016-01-30',
        [gate],
        { 'allowed' => ['req4', 'req5', 'req6'], 'deprecated' => ['req1', 'req2'] },
        { 'allowed' => ['res4', 'res5', 'res6'], 'deprecated' => ['res1', 'res2'] },
        initial_version
      )
      api_version
    end

    context 'without predecessor' do
      it 'gate is true for existing gates' do
        expect(initial_version.enabled?('allows_foo')).to be_truthy
      end

      it 'gate is false for non-existing gates' do
        expect(initial_version.enabled?('allows_cat')).to be_falsey
      end

      it 'request params should return just the allowed params' do
        expect(initial_version.request_params).to eq(['req1', 'req2', 'req3'])
      end

      it 'response params should return just the allowed params' do
        expect(initial_version.response_params).to eq(['res1', 'res2', 'res3'])
      end
    end

    context 'with predecessor' do
      it 'is true for existing gates' do
        expect(later_version.enabled?('allows_bar')).to be_truthy
      end

      it 'is true for predecessor existing gates' do
        expect(later_version.enabled?('allows_foo')).to be_truthy
      end

      it 'is false for non-existing gates' do
        expect(later_version.enabled?('allows_cat')).to be_falsey
      end

      it 'request params should return the filtered params' do
        expect(later_version.request_params).to eq(['req3', 'req4', 'req5', 'req6'])
      end

      it 'response params should return the filtered params' do
        expect(later_version.response_params).to eq(['res3', 'res4', 'res5', 'res6'])
      end
    end
  end
end