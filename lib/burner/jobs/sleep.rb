# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  class Jobs
    # Arbitrarily put thread to sleep for X number of seconds
    class Sleep < Job
      attr_reader :seconds

      def initialize(name:, seconds: 0)
        super(name: name)

        @seconds = seconds.to_f

        freeze
      end

      def perform(output, _payload)
        output.detail("Going to sleep for #{seconds} second(s)")

        Kernel.sleep(seconds)

        nil
      end
    end
  end
end
