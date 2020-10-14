# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  # Can take in a string and an object and use the object for formatting string interpolations
  # using tokens of form: {attribute_name}.  It can also understand dot-notation for nested
  # objects using the Objectable library.  Another benefit of using Objectable for resolution
  # is that it can understand almost any type of object: Hash, Struct, OpenStruct, custom
  # objects, etc.  For more information see underlying libraries:
  #   * Stringento: https://github.com/bluemarblepayroll/stringento
  #   * Objectable: https://github.com/bluemarblepayroll/objectable
  class StringTemplate
    include Singleton

    attr_reader :resolver

    def initialize
      @resolver = Objectable.resolver

      freeze
    end

    # For general consumption
    def evaluate(expression, input)
      Stringento.evaluate(expression, input, resolver: self)
    end

    # For Stringento consumption
    def resolve(value, input)
      resolver.get(input, value)
    end
  end
end
