# frozen_string_literal: true

require 'spec_helper'

describe QuakeLog::Entity::Player do
  describe '#initialize' do
    subject(:player) { described_class.new('id') }

    it 'instance a new player' do
      expect(player.id).to eq 'id'
      expect(player.score).to eq 0
    end
  end

  describe '#increase_score' do
    subject(:increase_score) { player.increase_score }
    let(:player) { described_class.new(:id) }

    it 'increases player score' do
      increase_score

      expect(player.score).to eq 1
    end
  end

  describe '#decrease_score' do
    subject(:decrease_score) { player.decrease_score }
    let(:player) { described_class.new(:id) }

    it 'decreases player score' do
      decrease_score

      expect(player.score).to eq(-1)
    end
  end
end
