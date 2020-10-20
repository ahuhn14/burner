# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Jobs::Collection::Shift do
  let(:value)      { %w[a b c] }
  let(:string_out) { StringOut.new }
  let(:output)     { Burner::Output.new(outs: string_out) }
  let(:payload)    { Burner::Payload.new(value: value) }

  subject { described_class.make(name: 'test', amount: amount) }

  describe '#perform' do
    context 'when amount is 1' do
      let(:amount) { 1 }

      it 'skips entries' do
        subject.perform(output, payload)

        expected = %w[b c]

        expect(payload.value).to eq(expected)
      end
    end

    context 'when amount is 2' do
      let(:amount) { 2 }

      it 'skips entries' do
        subject.perform(output, payload)

        expected = %w[c]

        expect(payload.value).to eq(expected)
      end
    end

    context 'when amount is 3' do
      let(:amount) { 3 }

      it 'skips entries' do
        subject.perform(output, payload)

        expected = []

        expect(payload.value).to eq(expected)
      end
    end
  end
end
