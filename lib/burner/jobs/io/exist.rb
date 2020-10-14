# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'base'

module Burner
  class Jobs
    module IO
      # Check to see if a file exists.  If short_circuit is set to true and the file
      # does not exist then the job will return false and short circuit the pipeline.
      class Exist < Base
        attr_reader :short_circuit

        def initialize(name:, path:, short_circuit: false)
          super(name: name, path: path)

          @short_circuit = short_circuit || false

          freeze
        end

        def perform(output, _payload, params)
          compiled_path = compile_path(params)

          exists = File.exist?(compiled_path)
          verb   = exists ? 'does' : 'does not'

          output.detail("The path: #{compiled_path} #{verb} exist")

          # if anything but false is returned then the pipeline will not short circuit.  So
          # we need to make sure we explicitly return false.
          short_circuit && !exists ? false : nil
        end
      end
    end
  end
end
