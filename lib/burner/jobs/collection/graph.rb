# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  class Jobs
    module Collection
      # Take an array of (denormalized) objects and create an object hierarchy from them.
      # Under the hood it uses Hashematics: https://github.com/bluemarblepayroll/hashematics.
      # Expected Payload#value input: array of objects.
      # Payload#value output: An array of objects.
      class Graph < Job
        attr_reader :key, :groups

        def initialize(name:, key:, config: Hashematics::Configuration.new)
          super(name: name)

          raise ArgumentError, 'key is required' if key.to_s.empty?

          @groups = Hashematics::Configuration.new(config).groups
          @key    = key.to_s

          freeze
        end

        def perform(output, payload)
          graph = Hashematics::Graph.new(groups).add(payload.value || [])

          output.detail("Graphing: #{key}")

          payload.value = graph.data(key)

          nil
        end
      end
    end
  end
end
