# frozen_string_literal: true

module Gates
  class Gate
    attr_accessor :name

    def initialize(name, description)
      @name = name
      @description = description
    end

    def ==(other_name)
      name.to_s == other_name.to_s
    end
  end
end
