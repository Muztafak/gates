# frozen_string_literal: true

module Gates
  class Params
    attr_reader :allowed, :deprecated

    def initialize(allowed, deprecated)
      @allowed = allowed
      @deprecated = deprecated
    end
  end
end