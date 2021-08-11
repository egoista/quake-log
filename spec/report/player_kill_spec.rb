# frozen_string_literal: true

require 'spec_helper'

describe QuakeLog::Report::PlayerKill do
  before do
    QuakeLog::Entity::Game.clear_games
    file = File.join(__dir__, '..', 'support', 'data', 'example.log')
    QuakeLog::LogParser.parse_file(file)
  end

  describe '.build' do
    subject { described_class.build(QuakeLog::Entity::Game.last) }
    let(:expected_result) do
      { "game_1" =>
        {
          "kills" => [
            {"Dono da Bola"=>5},
            {"Isgalamido"=>19},
            {"Zeh"=>20},
            {"Assasinu Credi"=>11}
          ],
          "players" => ["Dono da Bola", "Isgalamido", "Zeh", "Assasinu Credi"],
          "total_kills"=>105
        }
      }
    end

    it { is_expected.to eq expected_result }
  end
end
