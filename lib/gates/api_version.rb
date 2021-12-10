# frozen_string_literal: true

require 'active_support/core_ext/hash'

module Gates
  class ApiVersion
    attr_accessor :id, :gates, :actions, :predecessor

    def initialize(id, gates, actions, predecessor)
      @id = id
      @gates =
        begin
          gates.map do |gate_data|
            Gate.new(
              gate_data['name'],
              gate_data['description']
            )
          end
        rescue StandardError
          []
        end
      @actions =
        begin
          actions.map do |action_data|
            Actions::Action.new(
              action_data['name'],
              action_data['request'],
              action_data['response'],
              action_data['arguments']
            )
          end
        rescue StandardError
          []
        end
      @predecessor = predecessor
    end

    def enabled?(gate_name)
      if gates.include?(gate_name)
        true
      elsif !predecessor.nil?
        # recurse to check list of all gates less than or equal to this api
        # version
        !!predecessor.enabled?(gate_name)
      else
        false
      end
    end

    def request_params_for(action)
      allowed_params(action, :request)
    end

    def response_params_for(action)
      allowed_params(action, :response)
    end

    def arguments_params_for(action)
      allowed_params(action, :arguments)
    end



    def allowed_params(action, type)
      action_index = actions.index(action)
      allowed_params = action_index ? actions[action_index].send(type).allowed : {}
      puts "aaa #{allowed_params}"
      deprecated_params = action_index ? actions[action_index].send(type).deprecated : []
      puts "bbb #{deprecated_params}"
      predecessor = send(:predecessor)&.allowed_params(action, type) || {}
      filtered_params = params_handler(predecessor, deprecated_params)
      puts filtered_params

      filtered_params.deep_merge(allowed_params)
    end

    def params_handler(predecesor_params, deprecated_params)
      deprecated_params.each do |deprecated_param|
        case deprecated_param
        when Hash
          params_handler(predecesor_params[key = deprecated_param.keys.first], deprecated_param[key])
        else
          predecesor_params.delete(deprecated_param)
        end
      end
      predecesor_params
    end



  end
end