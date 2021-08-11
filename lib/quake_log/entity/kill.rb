# frozen_string_literal: true

module QuakeLog
  module Entity
    class Kill
      attr_accessor :murdered, :killer, :mean_of_death

      MEANS_OF_DEATH = %w[
        MOD_UNKNOWN MOD_SHOTGUN MOD_GAUNTLET MOD_MACHINEGUN MOD_GRENADE
        MOD_GRENADE_SPLASH MOD_ROCKET MOD_ROCKET_SPLASH MOD_PLASMA MOD_PLASMA_SPLASH
        MOD_RAILGUN MOD_LIGHTNING MOD_BFG MOD_BFG_SPLASH MOD_WATER MOD_SLIME MOD_LAVA
        MOD_CRUSH MOD_TELEFRAG MOD_FALLING MOD_SUICIDE MOD_TARGET_LASER MOD_TRIGGER_HURT
        MOD_NAIL MOD_CHAINGUN MOD_PROXIMITY_MINE MOD_KAMIKAZE MOD_JUICED MOD_GRAPPLE
      ].freeze

      def initialize(killer, murdered, mean_id)
        @killer = killer
        @murdered = murdered
        @mean_of_death = MEANS_OF_DEATH[mean_id.to_i]
      end

      def set_score
        if accident? || suicide?
          @murdered.decrease_score
        else
          @killer.increase_score
        end
      end

      def accident?
        @killer.is_a?(World)
      end

      def suicide?
        @killer.id == @murdered.id
      end
    end
  end
end
