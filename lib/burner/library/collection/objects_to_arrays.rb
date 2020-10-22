# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Library
    module Collection
      # Convert an array of objects to an array of arrays.  You can leverage the separator
      # option to support key paths and nested objects.  Pass in an array of
      # Burner::Modeling::KeyIndexMapping instances or hashable configurations which specifies
      # the key-to-index mappings to use.
      #
      # Expected Payload#value input: array of hashes.
      # Payload#value output: An array of arrays.
      #
      # An example using a configuration-first pipeline:
      #
      #   config = {
      #     jobs: [
      #       {
      #         name: 'set',
      #         type: 'set_value',
      #         value: [
      #           [1, 'funky']
      #         ]
      #       },
      #       {
      #         name: 'map',
      #         type: 'collection/objects_to_arrays',
      #         mappings: [
      #           { index: 0, key: 'id' },
      #           { index: 1, key: 'name' }
      #         ]
      #       },
      #       {
      #         name: 'output',
      #         type: 'echo',
      #         message: 'value is currently: #{__value}'
      #       },
      #
      #     ],
      #     steps: %w[set map output]
      #   }
      #
      #   Burner::Pipeline.make(config).execute
      class ObjectsToArrays < Job
        attr_reader :mappings

        # If you wish to support nested objects you can pass in a string to use as a
        # key path separator.  For example: if you would like to recognize dot-notation for
        # nested hashes then set separator to '.'.  For more information, see the underlying
        # library that supports this dot-notation concept:
        #   https://github.com/bluemarblepayroll/objectable
        def initialize(name:, mappings: [], separator: '')
          super(name: name)

          @mappings = Modeling::KeyIndexMapping.array(mappings)
          @resolver = Objectable.resolver(separator: separator.to_s)

          freeze
        end

        def perform(_output, payload)
          payload.value = array(payload.value).map { |object| key_to_index_map(object) }

          nil
        end

        private

        attr_reader :resolver

        def key_to_index_map(object)
          mappings.each_with_object(prototype_array) do |mapping, memo|
            memo[mapping.index] = resolver.get(object, mapping.key)
          end
        end

        def prototype_array
          Array.new(mappings.length)
        end
      end
    end
  end
end
