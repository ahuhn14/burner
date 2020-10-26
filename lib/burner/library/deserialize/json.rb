# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Library
    module Deserialize
      # Take a JSON string and deserialize into object(s).
      #
      # Expected Payload#value input: string of JSON data.
      # Payload#value output: anything, as specified by the JSON de-serializer.
      class Json < Job
        def perform(_output, payload)
          payload.value = JSON.parse(payload.value)
        end
      end
    end
  end
end
