# frozen_string_literal: true

require 'spec_helper'

describe QuakeLog::Entity::Kill do
  let(:kill) { described_class.new(killer, murdered, 1) }
  let(:killer) { QuakeLog::Entity::Player.new('killer_id') }
  let(:murdered) { QuakeLog::Entity::Player.new('murdered_id') }

  describe '#initialize' do
    subject(:new_kill) { described_class.new(killer, murdered, 1) }

    it 'instance a new kill' do
      expect(new_kill.killer).to be killer
      expect(new_kill.murdered).to be murdered
      expect(new_kill.mean_of_death).to eq 'MOD_SHOTGUN'
    end
  end

  describe '#set_score' do
    subject(:set_score) { kill.set_score }

    before do
      set_score
    end

    context 'when is an accident' do
      let(:killer) { QuakeLog::Entity::World.instance }

      it 'decreases murdered score' do
        expect(murdered.score).to eq(-1)
      end
    end

    context 'when is a suicide' do
      let(:killer) { murdered }

      it 'decreases murdered score' do
        expect(murdered.score).to eq(-1)
      end
    end

    context 'when is an assassination' do
      it 'increases killer score' do
        expect(killer.score).to eq 1
      end
    end
  end

  describe '#accident?' do
    subject { kill.accident? }

    context 'when killer is world' do
      let(:killer) { QuakeLog::Entity::World.instance }

      it { is_expected.to be_truthy }
    end

    context 'when killer is a player' do
      it { is_expected.to be_falsey }
    end
  end

  describe '#suicide?' do
    subject { kill.suicide? }

    context 'when killer is other player' do
      it { is_expected.to be_falsey }
    end

    context 'when killer is murdered' do
      let(:killer) { murdered }
      it { is_expected.to be_truthy }
    end
  end
end
