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
      #@request = request.map { |p| puts "#{p.class} ::: #{p}" }
      @response = response.map { |p| puts "#{p.class} ::: #{p}" }
      @request = Params.new(
        request['allowed'],
        request['deprecated']
      )
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
  end
end