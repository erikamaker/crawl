##############################################################################################################################################################################################################################################################
#####    PLAYER    ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require_relative 'inventory'
require_relative 'navigation'
require_relative 'board'
require_relative 'battling'


class Player
    include Inventory
    include Navigation
    include Battle
    attr_accessor :action, :target, :state, :sight, :pos, :items
    attr_accessor  :health, :armor, :defense, :weapon, :attack, :focus, :level
    attr_accessor :stun, :curse, :sleep, :sick, :tough, :smart, :trance
    def initialize
        super
        @action = :start
        @target = :start
        @state = :inert
        @sight = Array.new
        @pos = [0,1,2]
        @items = Array.new
        @health = 1
        @armor = nil
        @defense = 0
        @weapon = nil
        @attack = 0
        @focus = 3
        @level = 1
        @stun = 0
        @curse = 0
        @sleep = 0
        @sick = 0
        @tough = 0
        @smart = 0
        @trance = 0
    end
    def defense
        if armor_equipped
            [(@armor.profile[:defense] + @tough),4].min
        else [0 + @tough,4].min
        end
    end
    def equipped_weapon
        @weapon.targets[0].split.map(&:capitalize).join(' ')
    end
    def equipped_armor
        @armor.targets[0].split.map(&:capitalize).join(' ')
    end
    def clear_sight
        @sight.clear
    end
    def state_inert
        @state == :inert
    end
    def toggle_state_inert
        @state = :inert
    end
    def state_engaged
        @state == :engaged
    end
    def toggle_state_engaged
        moves = MOVES[1..16].flatten
        return if moves.none?(@action)
        @state = :engaged
    end
    def turn_page
        Board.increment_page(1)
        clear_sight
        @sight.concat(MOVES[15..16].flatten)
        toggle_state_inert
        cooldown_effects
        reset_input
    end
    def remove_from_inventory(item)
        @items.delete(item)
    end
end