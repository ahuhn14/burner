# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Library
    # Arbitrarily set value
    #
    # Expected Payload#value input: anything.
    # Payload#value output: whatever value was specified in this job.
    class SetValue < JobWithRegister
      attr_reader :value

      def initialize(name:, register: '', value: nil)
        super(name: name, register: register)

        @value = value

        freeze
      end

      def perform(_output, payload)
        payload[register] = value
      end
    end
  end
end
