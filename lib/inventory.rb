##############################################################################################################################################################################################################################################################
#####    INVENTORY    ########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require_relative 'interface'
require_relative 'vocabulary'


module Inventory
    include Interface
    def opening_or_viewing
        (MOVES[1] | MOVES[3]).include?(@action)
    end
    def inventory_selected
        INVENTORY.include?(Board.player.target)
    end
    def search_inventory(types)
        types = Array(types)
        @items.any? do |item|
            types.any? { |type| item.is_a?(type) }
        end || false
    end
    def all_item_types
        items.map { |item| item.class }
    end
    def remove_from_inventory
        items.delete(self)
    end
    def target_isnt_inventory
        INVENTORY.none?(@target)
    end
    def load_inventory
        @sight.concat(INVENTORY)
        return if target_isnt_inventory
        if opening_or_viewing
            open_inventory
            toggle_state_engaged
        end
    end
    def open_inventory
        print Rainbow("	   - You reach in your rucksack.\n\n").red
        if @items.empty?
            print "	   - It's empty.\n\n"
            print Rainbow("           - You tie your rucksack shut.\n\n").red
        else
            show_contents
            manage_inventory
    	end
    end
    def show_contents
        @items.group_by { |item| item.targets[0] }.each do |item, total|
            dots = 24 - item.length
            item_copy = item.split.map(&:capitalize).join(' ')
            print "	     #{item_copy} #{Rainbow('.').purple * dots} #{total.count}\n"
        end
    end
    def manage_inventory
        print Rainbow("\n\n	   - What next?").cyan
        print Rainbow("  >>  ").purple
        process_input
        item = @items.find { |item| item.targets.include?(@target) }
        puts "\n\n"
        bag_action(item)
        reset_input
    end
    def bag_action(item)
        if MOVES[1..14].flatten.none?(@action)
            puts "	   - Interact with your inventory"
            puts "	     as you would in the dungeon.\n\n"
            puts Rainbow("           - You tie your rucksack shut.\n").red
        elsif item.nil?
            puts Rainbow("           - That isn't in your inventory.\n").red
        elsif MOVES[2].include?(@action)
            puts Rainbow("           - That's already in your bag.\n").red
        else
            item.interact
            puts Rainbow("           - You tie your rucksack shut.\n").red
        end
    end
end