# frozen_string_literal: true

require 'spec_helper'


describe Gates::ApiVersion do
  describe '#enabled?' do
    let(:initial_version) do
      gate = { 'name' => 'allows_foo', 'description' => 'test description' }
      action = {
        'name' => 'fooAction',
        'request' => {
          'allowed' => { 'user' => 'String', something: 'Type' }
        },
        'arguments' => {
          'allowed' => { 'age' => 'Integer', 'delete' => 'Bool' }
        },
        'response' => {
          'allowed' => { 'name' => 'String', 'anything' => 'Type' }
        }
      }
      api_version = Gates::ApiVersion.new(
        '2020-01-01',
        [gate],
        [action],
        nil
      )
      api_version
    end
    let(:later_version) do
      gate = { 'name' => 'allows_bar', 'description' => 'another description' }
      action = {
        'name' => 'fooAction',
        'request' => {
          'allowed' => { 'new param' => 'new Type' },
          'deprecated' => [:something]
        },
        'arguments' => {
          'allowed' => { 'new param' => 'new Type' },
          'deprecated' => ['delete']
        },
        'response' => {
          'allowed' => { 'new param' => 'new Type' },
          'deprecated' => ['anything']
        }
      }
      api_version = Gates::ApiVersion.new(
        '2016-01-30',
        [gate],
        [action],
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
        expect(initial_version.request_params_for('fooAction')).to eq({"user"=>"String", :something=>"Type"})
      end

      it 'arguments params should return just the allowed params' do
        expect(initial_version.arguments_params_for('fooAction')).to eq({"age"=>"Integer", "delete"=>"Bool"})
      end

      it 'response params should return just the allowed params' do
        expect(initial_version.response_params_for('fooAction')).to eq({"name"=>"String", "anything"=>"Type"})
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
        expect(later_version.request_params_for('fooAction')).to eq({"user"=>"String", "new param"=>"new Type"})
      end

      it 'aruments params should return the filtered params' do
        expect(later_version.arguments_params_for('fooAction')).to eq({"age"=>"Integer", "new param"=>"new Type"})
      end

      it 'response params should return the filtered params' do
        expect(later_version.response_params_for('fooAction')).to eq({"name"=>"String", "new param"=>"new Type"})
      end
    end
  end
end
