##############################################################################################################################################################################################################################################################
#####    BATTLE    ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


module Battle
    ## SHARED BETWEEN CHARACTER CLASS AND PLAYER CLASS

    def weapon_equipped
        @weapon != nil
    end
    def weapon_name
        if @weapon != nil
            Rainbow(@weapon.targets[0].split.map(&:capitalize).join(' ')).orange
        else Rainbow("Bare Hands").orange
        end
    end
    def attack_points
        if weapon_equipped
            @weapon.profile[:damage] +
            type_bonus +
            @level +
            self.defense
        else @level
        end
    end
    def degrade_weapon
        if weapon_equipped
            @weapon.damage_item
            @weapon.break_item
        end
    end
    def degrade_armor
        if armor_equipped
            @armor.damage_item
            @armor.break_item
        end
    end
    def armor_equipped
        @armor != nil
    end
    def armor_name
        if @armor != nil
            Rainbow(@armor.targets[0].split.map(&:capitalize).join(' ')).orange
        else Rainbow("Bare Skin").orange
        end
    end
    def armor_points
        Rainbow("#{@armor.profile[:defense]}").green
    end

    def type_bonus
        @type == @weakness ? rand(2..3) : 0
    end
    def damage_received(magnitude)
        if (magnitude - @defense) > 0
            (magnitude - @defense)
        else 0
        end
    end
    def successful_hit
        rand((@focus.to_i)..4) > 3
    end
    def cooldown_effects
        states = [@stun, @curse, @sleep, @sick, @tough, @smart]
        states.each do |state|
          state -= 1 if state > 0
        end
    end
    def gain_health(magnitude)
        SoundBoard.heal_heart
        @health += (magnitude)
    end


    ## EXECUTED BY CHARACTER CLASS, FROM PLAYER PERSPECTIVE



    def print_damage
        if hearts_lost == 0
            print Rainbow("None\n\n").red
            return
        end
        hearts_lost.times do |index|
            print " " * 29 if index % 5 == 0 && index != 0
            print Rainbow("♥ ").red
            print "\n" if (index + 1) % 5 == 0 && index != 0
            print " "
            print "\n\n" unless hearts_lost % 5 == 0
        end
    end
    def character_death
        !@alive
        puts Rainbow("	   - You slay the #{targets[0]}, earning:\n").cyan
        @content.each {|item| puts("	       - 1 #{item.targets[0]}") if item}
        puts "\n"
        puts Rainbow("	   - You stuff the spoils of this").orange
        puts Rainbow("	     victory in your rucksack.\n").orange
        puts Rainbow("	   - The slain flesh catches fire").purple
        puts Rainbow("	     and disappears forever.\n").purple
        lose_all_items
        remove_from_board
    end
end