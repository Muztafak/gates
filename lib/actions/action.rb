# frozen_string_literal: true

module Actions
  class Action
    attr_reader :name, :request, :response, :arguments

    def initialize(name, request, response, arguments)
      @name = name
      @request = request ? Params.new(request['allowed'], request['deprecated']) : Params.new({}, [])
      @response = response ? Params.new(response['allowed'], response['deprecated']) : Params.new({}, [])
      @arguments = arguments ? Params.new(arguments['allowed'], arguments['deprecated']) : Params.new({}, [])
    end

    def ==(other_name)
      name.to_s == other_name.to_s
    end
  end
end