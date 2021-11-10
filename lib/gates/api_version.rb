# frozen_string_literal: true

module Gates
  class ApiVersion
    attr_accessor :id, :gates, :actions, :predecessor

    def initialize(id, gates, actions, predecessor)
      @id = id
      @gates = gates.map do |gate_data|
        Gate.new(
          gate_data['name'],
          gate_data['description']
        )
      end
      @actions = actions.map do |action_data|
        Actions::Action.new(
          action_data['name'],
          action_data['required_arguments'],
          action_data['optional_arguments'],
          action_data['response']
        )
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

    def required_params_for(action)
      allowed_params(action, :required_arguments)
    end

    def optional_params_for(action)
      allowed_params(action, :optional_arguments)
    end

    def response_params_for(action)
      allowed_params(action, :response)
    end

    def allowed_params(action, type)
      action_index = actions.index(action)
      allowed_params = action_index ? actions[action_index].send(type).allowed : {}
      puts "aaa #{allowed_params}"
      deprecated_params = action_index ? actions[action_index].send(type).deprecated : []
      puts "bbb #{deprecated_params}"
      predecessor = send(:predecessor)&.allowed_params(action, type) || {}
      deprecated_params.each { |key| predecessor.delete(key) }
      predecessor.merge(allowed_params)
    end
  end
end