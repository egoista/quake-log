# frozen_string_literal: true

require 'spec_helper'

describe QuakeLog::Entity::Game do
  before(:each) do
    QuakeLog::Entity::Game.clear_games
  end

  let(:game) { described_class.new }
  describe '#initialize' do
    subject(:new_game) { described_class.new }

    it 'instance a new game' do
      expect(new_game.players).to eq []
      expect(new_game.kills).to eq []
      expect(described_class.all).to eq [new_game]
    end
  end

  describe '.all' do
    subject { described_class.all }

    context 'when no game has been started' do
      it { is_expected.to eq [] }
    end

    context 'when a game has been started' do
      before do
        game
      end

      it { is_expected.to eq [game] }
    end
  end

  describe '.last' do
    subject { described_class.last }

    context 'when no game has been started' do
      it { is_expected.to eq nil }
    end

    context 'when a game has been started' do
      before do
        game
      end

      it { is_expected.to eq game }
    end
  end

  describe '#find_player' do
    subject { game.find_player(id) }

    context 'when is a game s player id' do
      let(:player) { game.create_player('id') }
      let(:id) { player.id }

      it { is_expected.to eq player }
    end

    context 'when is the World instance id' do
      let(:id) { QuakeLog::Entity::World.instance.id }

      it { is_expected.to eq QuakeLog::Entity::World.instance }
    end

    context 'when is an invalid id' do
      let(:id) { 'invalid' }

      it { is_expected.to eq nil }
    end
  end

  describe '#create_player' do
    subject(:create_player) { game.create_player(id) }

    context 'when is not world instance id' do
      let(:id) { 'id' }

      it 'adds a player to the game' do
        result = create_player

        expect(result).to be_a(QuakeLog::Entity::Player)
        expect(game.players).to include(result)
      end
    end

    context 'when is the World instance id' do
      let(:id) { QuakeLog::Entity::World.instance.id }

      it 'adds a player to the game' do
        result = create_player

        expect(result).to be_a(QuakeLog::Entity::World)
        expect(game.players).to_not include(result)
      end
    end
  end

  describe '#create_kill' do
    subject(:create_kill) { game.create_kill('killer_id', 'murdered_id', 1) }
    let!(:killer) { game.create_player('killer_id') }
    let!(:murdered) { game.create_player('murdered_id') }

    it 'adds a kill to the game' do
      result = create_kill

      expect(result).to be_a(QuakeLog::Entity::Kill)
      expect(result.killer).to be killer
      expect(result.murdered).to be murdered
      expect(game.kills).to include(result)
    end
  end

  describe 'calculate_score' do
    subject(:calculate_score) { game.calculate_score }
    let!(:killer) { game.create_player('killer_id') }
    let!(:murdered) { game.create_player('murdered_id') }
    let!(:world) { QuakeLog::Entity::World.instance }

    before do
      game.create_kill(killer.id, murdered.id, 1)
      game.create_kill(murdered.id, murdered.id, 1)
      game.create_kill(world.id, murdered.id, 1)

      calculate_score
    end

    it 'calculate game s players score' do
      expect(killer.score).to eq 1
      expect(murdered.score).to eq(-2)
    end
  end
end
