# frozen_string_literal: true

require 'spec_helper'

describe QuakeLog::Report::PlayerRanking do
  before do
    QuakeLog::Entity::Game.clear_games
    file = File.join(__dir__, '..', 'support', 'data', 'example.log')
    QuakeLog::LogParser.parse_file(file)
  end

  describe '.build' do
    subject { described_class.build(QuakeLog::Entity::Game.last) }
    let(:expected_result) do
      { "game_1" => [
        { 1 => ["Dono da Bola"] },
        { 2 => ["Assasinu Credi"] },
        { 3 => ["Isgalamido"] },
        { 4 => ["Zeh"] }
      ] }
    end

    it { is_expected.to eq expected_result }
  end
end
