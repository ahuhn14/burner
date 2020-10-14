# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Step do
  class MockJob < Burner::Job
    def perform(_output, _payload, _params)
      nil
    end
  end

  let(:job)        { MockJob.new(name: 'test') }
  let(:params)     { {} }
  let(:string_out) { StringOut.new }
  let(:output)     { Burner::Output.new(outs: string_out) }
  let(:payload)    { Burner::Payload.new }

  subject { described_class.new(job) }

  describe '#perform' do
    it 'delegates to Job#perform and adds __id and __value params' do
      all_params = params.merge(__id: output.id, __value: payload.value)

      expect(job).to receive(:perform).with(output, payload, all_params)

      subject.perform(output, payload, params)
    end

    it 'outputs the class name' do
      subject.perform(output, payload, params)

      expect(string_out.read).to include(job.class.name)
    end

    it 'outputs the name of the job' do
      subject.perform(output, payload, params)

      expect(string_out.read).to include(job.name)
    end

    it 'outputs completion message' do
      subject.perform(output, payload, params)

      expect(string_out.read).to include('Completed in')
    end
  end
end
