##############################################################################################################################################################################################################################################################
#####    TRADING    ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################

module Trade
    def talk
        if @hostile
            puts "	   - Talking won't help.\n\n"
        else
            conversation
        end
    end
    def conversation
        if @passive
            passive_script
        else business_as_usual
        end
    end
    def business_as_usual
        default_script
        barter if material_leverage
    end
    def barter
        unique_bartering_script
        print Rainbow("	   - Yes / No  ").cyan
        print Rainbow(">>  ").purple
        choice = gets.chomp.downcase.gsub(/[[:punct:]]/, '')
        print "\n"
        bartering_outcome(choice)
    end
    def bartering_outcome(choice)
        if AFFIRMATIONS.include?(choice)
            exchange_gifts
        else
            roll = rand(1..5)
            case roll
            when 1
                puts "	   - 'Nothing comes from nothing.'\n\n"
            when 2
                puts "	   - 'If you change your mind...'\n\n"
            when 3
                puts "	   - 'Why not? You can trust me.'\n\n"
            when 4
                puts "	   - 'Forget it, then. Never mind.'\n\n"
            when 5
                puts "	   - 'I promise a very fair trade.'\n\n"
            end
        end
    end
    def exchange_gifts
            reward_animation
            reward = @rewards.sample
            puts "	   - To help you on your journey,"
            puts "	     you're given 1 #{reward.targets[0]}.\n\n"
            reward.take
            @content.concat([@weapon,@desires])
            @@player.remove_from_inventory(material_leverage)
            become_passive

    end
    def lose_all_items
        @content.each {|item| item.push_to_player_inventory if item}
    end
end