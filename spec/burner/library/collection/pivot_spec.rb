# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'file_helper'
require 'spec_helper'

describe Burner::Library::Collection::Pivot do
  let(:denormalized_patients) { read_yaml_file('spec', 'fixtures', 'denormalized_patients.yaml') }
  let(:normalized_patients)   { read_yaml_file('spec', 'fixtures', 'normalized_patients.yaml') }

  let(:string_out)      { StringIO.new }
  let(:output)          { Burner::Output.new(outs: [string_out]) }
  let(:register)        { 'register_a' }
  let(:payload)         { Burner::Payload.new(registers: { register => normalized_patients }) }
  let(:unique_keys)     { %w[practice_id patient_id] }
  let(:other_keys)      { %w[favorite_doctor] }
  let(:pivot_key)       { :key }
  let(:pivot_value_key) { :value }
  let(:insensitive)     { false }

  subject do
    described_class.make(
      insensitive: insensitive,
      name: 'test',
      other_keys: other_keys,
      pivot_key: pivot_key,
      pivot_value_key: pivot_value_key,
      register: register,
      unique_keys: unique_keys
    )
  end

  describe '#perform' do
    before do
      subject.perform(output, payload)
    end

    it 'sets # of records uniquely' do
      actual = payload[register]

      expect(actual.length).to eq(denormalized_patients.length)
    end

    it 'has the right pivoted data' do
      actual = payload[register]

      expect(actual).to match_array(denormalized_patients)
    end

    context 'when insensitive' do
      let(:insensitive) { true }

      it 'treats keys as lowercase string for uniqueness' do
        actual = payload[register]

        expect(actual.length).to eq(denormalized_patients.length)
      end
    end
  end
end
