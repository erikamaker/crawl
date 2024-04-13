##############################################################################################################################################################################################################################################################
#####    BOARD    ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require_relative 'vocabulary'
require_relative 'player'

class Board
    include Interface
    def initialize
        @@page = 0
        @@map = Array.new
        @@player = Player.new
    end
    def self.player_actions
    {
        view: MOVES[1],
        take: MOVES[2],
        open: MOVES[3],
        push: MOVES[4],
        pull: MOVES[5],
        talk: MOVES[6],
        attack: MOVES[7],
        craft: MOVES[8],
        burn: MOVES[9],
        eat: MOVES[10],
        drink: MOVES[11],
        mine: MOVES[12],
        lift: MOVES[13],
        equip: MOVES[14]
    }
    end
    def self.player
        @@player
    end
    def self.world_map
        @@map
    end
    def self.page_count
        @@page
    end
    def self.increment_page(count)
        @@page += count
    end
    def self.decrement_page(count)
        @@page -= count
    end
    def self.present_list_of_items(items)
        cond_1 = @@player.inventory_selected
        cond_2 = MOVES[15].include?(@@player.target)
        cond_3 = MOVES[16].include?(@@player.target)
        cond_4 = @@player.state_engaged
        cond_5 = items.none? { |item| item.location.include?(@@player.pos) }
        cond_6 = [cond_1, cond_2, cond_3, cond_4, cond_5]
        present = Rainbow("	   - Here you find:\n").magenta
        puts present if cond_6.none?
        items.each{ |item| item.activate}
        print "\n" if [cond_4,cond_5].none?
    end
    def self.run_level(rooms,fixtures,npcs,items,loot)
        system("clear")
        print "\e[?25h"
        print "\e[8;45;57t"
        loop do
            Board.player.action_select
            system("clear")
            Board.player.header
            Board.player.detect_movement
            Board.player.suggest_tutorial
            Board.player.tutorial_screen
            Board.player.stats_screen
            rooms.each { |room| room.activate}
            fixtures.each { |fixture| fixture.activate }
            npcs.each { |npc| npc.activate }
            Board.present_list_of_items(items)
            Board.player.load_inventory
            Board.player.target_does_not_exist
            Board.player.game_over
            Board.player.turn_page
            Board.player.page_top
            Board.player.page_bottom
        end
    end
end