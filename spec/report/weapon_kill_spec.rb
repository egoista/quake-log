# frozen_string_literal: true

require 'spec_helper'

describe QuakeLog::Report::WeaponKill do
  before do
    QuakeLog::Entity::Game.clear_games
    file = File.join(__dir__, '..', 'support', 'data', 'example.log')
    QuakeLog::LogParser.parse_file(file)
  end

  describe '.build' do
    subject { described_class.build(QuakeLog::Entity::Game.last) }
    let(:expected_result) do
      {
        "game_1" => {
          "kills_by_means" => {
            "MOD_FALLING" => 11,
            "MOD_MACHINEGUN" => 4,
            "MOD_RAILGUN" => 8,
            "MOD_ROCKET" => 20,
            "MOD_ROCKET_SPLASH" => 51,
            "MOD_SHOTGUN" => 2,
            "MOD_TRIGGER_HURT"=>9
          }
        }
      }
    end

    it { is_expected.to eq expected_result }
  end
end
