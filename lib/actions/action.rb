# frozen_string_literal: true

module Actions
  class Action
    attr_reader :name, :required_arguments, :optional_arguments, :response

    def initialize(name, required_arguments, optional_arguments, response)
      @name = name
      @required_arguments = Params.new(required_arguments['allowed'], required_arguments['deprecated'])
      @optional_arguments = Params.new(optional_arguments['allowed'], optional_arguments['deprecated'])
      @response = Params.new(response['allowed'], response['deprecated'])
    end

    def ==(other_name)
      name.to_s == other_name.to_s
    end
  end
end