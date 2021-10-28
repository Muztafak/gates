# frozen_string_literal: true

module Gates
  class Params
    def initialize(allowed, deprecated)
      @allowed = allowed
      @deprecated = deprecated
    end
  end
end