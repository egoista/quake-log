# frozen_string_literal: true

require 'spec_helper'

describe QuakeLog::Entity::World do
  describe '.instance' do
    subject { described_class.instance }

    it { is_expected.to be described_class.instance }
  end

  describe '.new' do
    it 'raises an error' do
      expect { described_class.new }.to raise_error(NoMethodError)
    end
  end

  describe '#id' do
    subject { described_class.instance.id }

    it { is_expected.to eq '1022' }
  end
end
