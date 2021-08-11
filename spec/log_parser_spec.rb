# frozen_string_literal: true

require 'spec_helper'

describe QuakeLog::LogParser do
  before(:each) do
    QuakeLog::Entity::Game.clear_games
  end

  let(:file) do
    File.join(__dir__, 'support', 'data', 'example.log')
  end

  describe '.parse_file' do
    subject! { described_class.parse_file(file) }
    let(:game) { QuakeLog::Entity::Game.last }

    it 'builds a game' do
      expect(QuakeLog::Entity::Game.all.size).to eq 1
      expect(game.players.size).to eq 4
      expect(game.kills.size).to eq 105
    end
  end

  describe '.parse_line' do
    subject(:parse_line) { described_class.parse_line(line) }

    context 'when match InitGame' do
      let(:line) { '  1:47 InitGame: \\sv_floodProtect\\' }

      it 'builds a new game' do
        expect { parse_line }.to change { QuakeLog::Entity::Game.all.size }.by(1)
      end
    end

    context 'when match ClientConnect' do
      let(:line) { '  1:47 ClientConnect: 2' }

      before do
        QuakeLog::Entity::Game.new
      end
      it 'builds a new player' do
        expect { parse_line }.to change { QuakeLog::Entity::Game.last.players.size }.by(1)
      end
    end

    context 'when match ClientUserinfoChanged' do
      let(:line) { '  1:47 ClientUserinfoChanged: 2 n\\Dono da Bola\\t\\' }
      let(:game) { QuakeLog::Entity::Game.new }
      let!(:player) { game.create_player('2') }

      it 'updates player name' do
        expect(player.name).to eq nil
        parse_line
        expect(player.name).to eq 'Dono da Bola'
      end
    end

    context 'when match Kill' do
      let(:line) { '  2:11 Kill: 2 4 6: Dono da Bola killed Zeh by MOD_ROCKET' }
      let(:game) { QuakeLog::Entity::Game.new }

      before do
        game.create_player('2')
        game.create_player('4')
      end
      it 'builds a new kill' do
        expect { parse_line }.to change { game.kills.size }.by(1)
      end
    end
  end

  describe '.total_lines' do
    subject { described_class.total_lines(file) }

    it { is_expected.to eq 504 }
  end
end
