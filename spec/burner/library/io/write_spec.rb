# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::IO::Write do
  let(:path)       { File.join(TEMP_DIR, "#{SecureRandom.uuid}.txt") }
  let(:params)     { { path: path } }
  let(:string_out) { StringOut.new }
  let(:output)     { Burner::Output.new(outs: string_out) }
  let(:value)      { 'I should be written to disk.' }
  let(:payload)    { Burner::Payload.new(params: params, value: value) }

  subject { described_class.make(name: 'test', path: '{path}') }

  describe '#perform' do
    before(:each) do
      subject.perform(output, payload)
    end

    it "writes payload's value to file" do
      actual = File.open(path, 'r', &:read)

      expect(actual).to eq(value)
    end

    it 'adds WrittenFile instance to Payload#side_effects' do
      expect(payload.side_effects.length).to                  eq(1)
      expect(payload.side_effects.first.logical_filename).to  eq(path)
      expect(payload.side_effects.first.physical_filename).to eq(path)
    end
  end
end
