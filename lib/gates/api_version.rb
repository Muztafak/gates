# frozen_string_literal: true

module Gates
  class ApiVersion
    attr_accessor :id, :gates, :request, :response, :predecessor

    def initialize(id, gates, request, response, predecessor)
      @id = id
      @gates = gates.map do |gate_data|
        Gate.new(
          gate_data['name'],
          gate_data['description']
        )
      end
      @request = Params.new(request['allowed'], request['deprecated'])
      @response = Params.new(response['allowed'], response['deprecated'])
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

    def request_params
      allowed_params(:request)
    end

    def response_params
      allowed_params(:response)
    end

    def allowed_params(type)
      allowed_params = send(type).allowed || []
      puts "aaa #{allowed_params}"
      deprecated_params = send(type).deprecated || []
      puts "bbb #{deprecated_params}"
      (predecessor&.allowed_params(type) || []) + allowed_params - deprecated_params
    end
  end
end