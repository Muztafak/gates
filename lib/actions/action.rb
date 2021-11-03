# frozen_string_literal: true

module Actions
  class Action
    attr_reader :name, :request, :response

    def initialize(name, request, response)
      @name = name
      @request = Params.new(request['allowed'], request['deprecated'])
      @response = Params.new(response['allowed'], response['deprecated'])
      @allowed = allowed
      @deprecated = deprecated
    end
  end
end