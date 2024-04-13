##############################################################################################################################################################################################################################################################
#####    GAMEPIECE    ########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require_relative 'board'
require_relative 'sound'
require_relative 'player'
require_relative 'battling'


class Gamepiece < Board
    attr_accessor :location, :targets, :moveset, :profile
    def initialize
        # Ensure we can access all Board
        # parent methods.
        super
    end
    def display_backdrop
        # This acts as the visible asset.
        # Most pieces have one, except for
        # hidden items that return nil.
    end
    def special_behavior
        # Unique behavior at activation.
        # EG. Fruit trees grow new fruit.
        # EG. Characters can retaliate.
        # EG. Tiles supply coords to @@map.
        # EG. Pull switches reveal things.
    end
    def execute_special_behavior
        # Populates vocabulary with targets.
        EXISTING_TARGETS.concat(targets)
        special_behavior
    end
    def remove_from_board
        # Without a proper position, this
        # ensures piece removal from game.
        @location = [0]
    end
    def reveal_targets_to_player
        # Populates player's line of sight
        # with the piece's target keywords.
        @@player.sight |= targets
    end
    def player_near
        # Used in activation method below.
        @location.include?(@@player.pos)
    end
    def view
        # All pieces in player @sight are
        # viewable. This chains two methods
        # together that describe the piece's
        # state, and its detailed profile.
        display_description
        display_profile
        print "\n"
    end
    def display_profile
        # A @profile holds the keys / value
        # pairs for specific descriptive or
        # statistical data.
        return if @profile.nil?
        @profile.each do |key, value|
            length = 25 - (key.to_s.length + value.to_s.length)
            dots = Rainbow(".").purple * length
            space = " " * 13
            value = value.to_s.capitalize
            puts space + "#{key.capitalize} #{dots} #{value}"
        end
    end
    def interpret_action
        # Registers player's chosen @action,
        # if it exists within Board's actions.
        Board.player_actions.each do |action, moves|
            send(action) if moves.include?(@@player.action)
        end
    end
    def activate
        # First, execute any special behavior.
        # Determine whether player can see it.
        # Show idle backdrop, or interact script.
        execute_special_behavior
        player_near ? reveal_targets_to_player : return
        @@player.state_inert ? display_backdrop : interact
    end
    def wrong_move
        # Default exception for when player
        # selects a wrong move. It's helpful
        # to write unique hints for a piece.
        puts "	   - It would be uesless to try."
        puts "	     A page passes in vain.\n\n"
    end
    def interact
        # If the player targets the piece, it
        # will check the chosen @move against
        # list of possible moves, and behaves
        # according to the result.
        return if targets.none?(@@player.target)
        if moveset.include?(@@player.action)
            interpret_action
        else wrong_move
        end
    end
end


##############################################################################################################################################################################################################################################################
#####    FIXTURES    #########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Fixture < Gamepiece
    def moveset
        # A player can only view a fixture.
        # It does nothing but describe. A
        # fixture helps build the player's
        # world, and the push the story.
        MOVES[1]
    end
end


##############################################################################################################################################################################################################################################################
#####    TILES    ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Tiles < Fixture
    # The physical world that both player
    # and pieces inhabit is built of tiles.
    attr_accessor  :subtype, :composition, :terrain
    attr_accessor  :borders, :general, :targets
    def initialize
        super
        # A room should have the following
        # target attributes, for unique and
        # nested interaction.
        @general = ["around","room","area","surroundings"] | subtype
        @borders = [["wall", "walls"],
                    ["floor","down", "ground"],
                    ["ceiling","up","canopy"]]
        @terrain = ["terrain","medium","material"] | composition
        @targets = (general + terrain + borders).flatten
    end
    def view
        # Display unique bird's eye view of
        # the player-occupied room.
        overview
    end
    def special_behavior
        # Supply overall map with @location.
        @@map |= @location
    end
    def interpret_action
        # The player can observe, with varying
        # specificity, the tile's attributes.
        case @@player.target
        when *general
            # toggle_state_inert in order to display
            # any items from level activating and
            # displaying their own backdrops.
            @@player.toggle_state_inert
            overview
        when *terrain
            # View the terrain
            view_type
            # View the walls
        when *borders[0]
            view_wall
            # View the floor
        when *borders[1]
            view_down
            # View the ceiling
        when *borders[2]
            view_above
        end
    end
end


##############################################################################################################################################################################################################################################################
#####    PORTABLE     ########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Portable < Gamepiece
    def moveset
        # Items can be viewed or taken.
    	MOVES[1..2].flatten
    end
    def display_backdrop
        # Show in list-format. For context,
        # see the Board's load_loot method.
        print "             "
        print Rainbow("1 #{targets[0].split.map(&:capitalize).join(' ')} ").orange
        display_position
    end
    def display_position
        # From Board: "At this coordinate, you find:"
        # From level file:
        #    def eg_item.display_position
        #       puts "lays on the table."   < -- Follow style
        #    end
        # Complete: 1 {targets[0]} {position}
    end
    def wrong_move
        # Basic loot without equipability
        # (in contrast w/ weapons or armor)
        # can only be viewed or taken.
        print "	   - This portable object can be\n"
        print Rainbow("	     viewed").cyan + " or "
        print Rainbow("taken").cyan + ".\n\n"
    end
    def take
        # First execute view (for pacing).
        self.view
        puts Rainbow("	   - You take the #{targets[0]}.\n").orange
        push_to_player_inventory
        SoundBoard.found_item
    end
    def push_to_player_inventory
        # Eliminate the item from the world
        remove_from_board
        # Give it to the player
        @@player.items.push(self)
    end
end


##############################################################################################################################################################################################################################################################
#####     CONTAINERS     #####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Container < Gamepiece
    # This piece exists to hide things from
    # the player. This includes loot inside
    # traditional containers, up to entire
    # rooms behind doors. @key is toggleable.
    attr_accessor :content, :key, :state
    def initialize
        super
        @state = :"closed shut"
        @key = false
    end
    def moveset
        # Can be viewed or opened.
        @moveset = MOVES[1] | MOVES[3]
    end
    def toggle_state_open
        # See open method for context.
        @state = :"already open"
    end
    def view
        # "closed shut" or "already open"
    	puts "	   - This #{targets[0]} is #{state}.\n\n"
    end
    def key
        # Searches player for a key, or
        # a lockpick. Both are accepted.
        @@player.items.find {|i| i.is_a?(Lockpick) or  i.is_a?(Key)}
    end
    def open
        # Player's method to reveal the
        # piece's hidden content.
        if @state == :"closed shut"
            @key ? is_locked : give_content
        else puts "	   - This #{targets[0]}'s already open.\n\n"
        end
    end
    def is_locked
        # If player has no item to unlock
        # the container, it will not open.
        # Otherwise, we use it to unlock.
        if key.nil?
            puts "	   - It won't open. It's locked.\n\n"
        else
            puts "	   - You twirl a #{key.targets[0]} in the"
            print "	     #{targets[0]}'s latch. "
            print Rainbow("Click.\n\n").orange
            use_key
            give_content
        end
    end
    def use_key
        # The first found key or lock pick
        # will be the same that unlocked.
        # See Tool subclass for @lifespan
        # and break_item context.
        key.profile[:lifespan] -= 1
        key.break_item
    end
    def give_content
        # In traditional containers, content
        # is a portable loot item. Therefore,
        # the player must take the content.
        # This method is different for doors.
        puts Rainbow("           - It swings open and reveals a").cyan
        puts Rainbow("             hidden #{content.targets[0]}.\n").cyan
        toggle_state_open
        content.take
    end
    def wrong_move
        print "	   - This container can only be\n"
        print Rainbow("	     viewed").cyan + " or "
        print Rainbow("opened").cyan + ".\n\n"
    end
end


##############################################################################################################################################################################################################################################################
#####    COMBUSTIBLES    #####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Burnable < Portable
    def moveset
        # Can be viewed, taken, or burned.
        MOVES[1..2].flatten + MOVES[9]
    end
    def matchstick
        # Check player for a matchstick
        # A matchstick is required to
        # initially burn anything.
        @@player.items.find {|i| i.is_a?(Match)}
    end
    def fuel
        # Some burnable objects require
        # fuel to function.
        @@player.items.find { |item| item.is_a?(Fuel) }
    end
    def fire_near
        # Boolean check for nearby fire.
        @@player.sight.include?("fire")
    end
    def burn
        # First, check if fire is near.
        # Burning evokes display and
        # removes piece from the game.
        if fire_near
            unique_burn_screen
            remove_from_board
        # Priotize using a matchstick
        # if there isn't any fire near.
        elsif @@player.search_inventory(Match)
            use_match
        else
            puts "	   - There isn't any fire here.\n\n"
        end
    end
    def use_match
        # Display striking matchstick.
        # Each can be used only once.
        puts "	   - You strike a matchstick on"
        puts "	     the floor. It ignites.\n\n"
        # Execute the same unique burn
        # screen as a local fire would.
        unique_burn_screen
        matchstick.profile[:lifespan] -= 1
        matchstick.break_item
        remove_from_board
    end
    def wrong_move
        print "	   - This combustible object can be\n"
        print Rainbow("	     viewed").cyan + " or "
        print Rainbow("burned").cyan + ".\n\n"
    end
end


##############################################################################################################################################################################################################################################################
#####    EDIBLE    ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Edible < Portable
    def targets
        # subtype specifies food name
    	subtype | ["food","edible","nourishment","nutrients","nutrient"]
    end
    def moveset
        # Can be viewed, taken, or ingested.
    	MOVES[1..2].flatten | MOVES[10]
    end
    def animate_ingestion
        # Signals to user the item is
        # being successfully eaten.
        puts Rainbow("	   - You eat the #{subtype[0]}, healing").orange
    	print Rainbow("	     #{heal_amount} heart").orange
        print Rainbow("#{heal_amount == 1 ? '.' : 's.'} ").orange
    end
    def remove_portion
        # All edible items are built with
        # a portion count that decrements
        # when the preset is eaten.
        profile[:portions] -= 1
    end
    def display_remaining_portions
        # Shows player how many portions
        # are left after one is eaten.
        case profile[:portions]
        when 1
            print "#{profile[:portions]} portion left.\n\n"
        when * [2..7]
            print "#{profile[:portions]} portions left.\n\n"
        else print "You finish it.\n\n"
            # Once the portions reaches 0,
            # remove from board and player.
            remove_from_board
            @@player.remove_from_inventory(self)
        end
    end
    def heal_amount
        # Check if player's health plus
        # the number of hearts preset
        # can heal is over 4.
        if @@player.health + profile[:hearts] > 4
            # If so, just fill player up to 4.
            (4 - @@player.health)
            # Else the standard number applies.
        else profile[:hearts]
        end
    end
    def activate_side_effects
        # Reserved for stat changes on
        # player state. See presets.
    end
    def eat
        # Main method chain of above.
        animate_ingestion
        remove_portion
        display_remaining_portions
        # See Battle module for gain_health.
        @@player.gain_health(heal_amount)
        activate_side_effects
    end
    def wrong_move
        print "	   - This food item can only be\n"
        print Rainbow("	     viewed").cyan + " or "
        print Rainbow("ingested").cyan + ".\n\n"
    end
end


##############################################################################################################################################################################################################################################################
#####    LIQUID    ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Liquid < Edible
    def targets
        # subtype specifies drink name
    	subtype | ["drink","liquid","fluid"]
    end
    def moveset
        # This item can be viewed, taken,
        # eaten, or drank. Why both?
    	[MOVES[1..2],MOVES[10..11]].flatten
    end
    def drink
        # Because it invokes the same 'eat'
        # behavior, for more move options.
        eat
    end
    def animate_ingestion
        # Same rules as animating edibles.
        puts Rainbow("	   - You drink the #{subtype[0]}, healing").orange
    	print Rainbow("	     #{heal_amount} heart").orange
        print Rainbow("#{heal_amount == 1 ? '.' : 's.'} ").orange
    end
    def wrong_move
        print "	   - This liquid item can only be\n"
        print Rainbow("	     taken").cyan + " or "
        print Rainbow("ingested").cyan + ".\n\n"
    end
end


##############################################################################################################################################################################################################################################################
#####    FRUIT SOURCE    #####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class FruitSource < Edible
    # This piece spawns multiples of
    # fruit. Couple with trees.
    attr_accessor :type
    def initialize
        super
        # This method ensures that we spawn
        # the stock only once. Initializing
        # individual fruit (e.g. Apple.new)
        # during main loop resets the game's
        # whole state. Preloading is the fix.
        @count = 999
        @stock = []
        @fruit = []
        fill_stock
    end
    def fill_stock
        @count.times do
            push_stock
        end
    end
    def targets
        # See presets.rb for subtypes.
        subtype | ["fruit", "produce"]
    end
    def display_description
        # Only display if the fruit count
        # is > 0, else signal to wait.
        if @fruit.count > 0
            @type.display_description
        else fruit_unripe
        end
    end
    def display_profile
        # Similarly, we  display the fruit
        # fruit preset @type's profile if
        # @fruit count is > 0. No else.
        if @fruit.count > 0
            @type.display_profile
        end
    end
    def display_backdrop
        # Unlike a @type's usual backdrop,
        # a fruit source will only display
        # the count available, if any.
        fruit = "#{@fruit.count} ripened #{subtype[0]}"
        return if @fruit.count < 1
        print "	   - It bears"
        print Rainbow(" #{fruit}").orange
        if @fruit.count == 1
            puts Rainbow(".\n").orange
        elsif @fruit.count != 0
            puts Rainbow("s.\n").orange
        end
    end
    def grow_fruit
        # The fruit @type's custom page
        # counter determining a preset's
        # harvest cycle.
        if harvest_time # (e.g. every 30 pages)
            @fruit.push(@stock[0])
            @stock.shift
        end
    end
    def special_behavior
        # If 3 fruit occupy the source,
        # stop spawning. Else, spawn!
        @fruit.count < 3 && grow_fruit
    end
    def fruit_unripe
        # Display signal to  player that
        # fruit count is currently 0.
        return if @fruit.count > 0
        puts "	   - The fruit needs time to grow"
        puts "	     before it can be harvested."
        @@player.toggle_state_inert
    end
    def take
        # If the count of fruit is > 0,
        # player takes the first index,
        # and the stock's queue shifts.
        if @fruit.count > 0
            @fruit[0].take
            @fruit.shift
        else fruit_unripe
            print "\n"
        end
    end
    def eat
        # This was a stylistic choice.
        # Unwanted behavior may occur
        # if default method is favored.
        puts "	   - You can't eat fruit that you"
        puts "	     haven't harvested.\n\n"
        take
    end
end


##############################################################################################################################################################################################################################################################
#####    TOOLS     ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Tool < Portable
    # This is a special type of item
    # that can be equipped (mostly).
    def moveset
    	MOVES[1..2].flatten | MOVES[14]
    end
    def damage_item
        profile[:lifespan] -= 1
    end
    def targets
        subtype | ["tool"]
    end
    def equip
        puts "	   - This object will auto-equip"
        puts "	     during its time of need.\n\n"
    end
    def break_item
        if profile[:lifespan] == 0
            puts Rainbow("	   - Your #{targets[0]} breaks in two.").red
            puts Rainbow("	     You drop the broken pieces.\n").red
            @@player.remove_from_inventory(self)
            @@player.weapon = nil if self == @@player.weapon
        end
    end
end


##############################################################################################################################################################################################################################################################
#####    WEAPONS    ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Weapon < Tool
  def targets
    subtype | ["weapon"]
  end
  def equip
    SoundBoard.equip_item
    self.push_to_player_inventory if @@player.items.none?(self)
    view
    puts Rainbow("	   - You equip the #{targets[0]}.\n").orange
    @@player.weapon = self
  end
  def wrong_move
    print "	   - This weapon can be"
    print Rainbow(" examined").cyan + ",\n"
    print Rainbow("	     taken").cyan + ", or "
    print Rainbow("equipped").cyan + ".\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####     PULL SWITCHES     ##################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Pullable < Gamepiece
  attr_accessor :content
  def initialize
    super
    @moveset = MOVES[1] | MOVES[5]
    @pulled = false
  end
  def special_behavior
    content.activate if @pulled == true
  end
  def toggle_state_pulled
    @pulled = true
  end
  def reveal_secret
    reveal_secret_text
    @@player.toggle_state_inert
  end
  def pull
  	unless @pulled
  	  reveal_secret
      toggle_state_pulled
  	else
      puts "	   - It appears that somebody has\n"
  	  puts "	     already pulled this #{targets[0]}.\n\n"
  	end
  end
  def wrong_move
    print "	   - This pull switch can only be\n"
    print Rainbow("	     examined").cyan + ", or "
    print Rainbow("pulled").cyan + ".\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####     CHARACTERS     #####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Character < Gamepiece
    include Battle
    attr_accessor :regions, :desires, :content, :rewards, :alive, :tough
    def initialize
        super
        @profile = {}
        @moveset = (MOVES[1] | MOVES[6..7]).flatten
        @hostile = false
        @content = [@weapon,@armor,@rewards]
        @sigil = nil
        @health = 0
        @alive = @health > 0
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
    def update_profile
        @profile[:heatlh] = @health
        @profile[:defense] = @defense
        @profile[:hostile] = @hostile
        @profile[:focus] = @focus
        @profile[:sigil] = @sigil
        @profile[:tough] = @tough
        self.cooldown_effects
        @content = [@rewards,@armor,@weapon].compact
    end
    def targets
        subtype | ["character","person","npc"]
    end

    def material_leverage
        @@player.items.find do |item|
            item.targets == desires.targets
        end
    end
    def display_backdrop
        @hostile ? hostile_backdrop : docile_backdrop
    end
    def activate
        player_near ? reveal_targets_to_player : return
        return if MOVES[15].include?(@@player.target)
        @@player.state_inert ? display_backdrop : interact
        execute_special_behavior
    end
    def special_behavior
        update_profile
        attack_player if (@hostile and @alive)
    end
    def become_hostile
        unless @hostile
            @hostile = true
            @location = @regions
        end
    end
    def become_passive
        @hostile = false
    end
    def wrong_move
        puts "	   - The #{targets[0]} leers at you. You"
        puts "	     shouldn't annoy the locals.\n\n"
    end
    def talk
        if @hostile
            puts "	   - Talking won't help.\n\n"
        else conversation
        end
    end
    def conversation
        if @desires != nil
            business_as_usual
        else passive_script
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
            @speech = [
                "	   - 'Nothing comes from nothing.'\n\n",
                "	   - 'Just think about it, friend.'\n\n",
                "	   - 'What? You don't trust me?'\n\n",
                "	   - 'Forget it, then.'\n\n",
                "	   - 'I offer a very fair trade.'\n\n",
                "	   - '... Fine. Your loss.'\n\n"]
                become_hostile if rand(1..8) == 8
            puts @speech.sample
        end
    end
    def exchange_gifts
        reward_animation
        reward = @rewards
        puts "	   - To help you on your journey,"
        puts "	     you're given 1 #{Rainbow(reward.targets[0]).orange}.\n\n"
        reward.push_to_player_inventory
        @@player.remove_from_inventory(material_leverage)
        @hostile = false
        @desires = nil
        @rewards = nil
    end
    def lose_all_items
        @content.each { |item| item.push_to_player_inventory }
    end
    def attack
        become_hostile
        puts "	   - You move to strike with your"
        print "	     #{@@player.weapon_name}. "
        if @@player.successful_hit
            puts Rainbow("Success.\n").green
            @@player.degrade_weapon
            @health -= character_hearts_lost
            character_damage if @alive
            character_death !@alive
        else puts Rainbow("You miss.\n").red
            ## CHANCE OF DEMON PARRY
        end
    end
    def attack_player
        puts "	   - The #{targets[0]} lunges to attack"
        print "	     with its #{weapon_name}.\n\n"
        if successful_hit
            SoundBoard.take_damage
            @@player.health -= player_hearts_lost
            @@player.display_defense
            print Rainbow("	   - It costs you #{player_hearts_lost} heart point").red
            player_hearts_lost != 1 && print(Rainbow("s").red)
            print Rainbow(".\n\n").red
            @@player.degrade_armor
            ## CHANCE OF EFFECTS
        else puts Rainbow("	   - You narrowly avoid its blow.\n").green
        end
    end
    def character_hearts_lost
        damage_received(@@player.attack_points)
    end
    def player_hearts_lost
        [@@player.damage_received(attack_points),4].min
    end
    def display_defense
        if armor_equipped
            print Rainbow("	   - Your #{armor_name} ").cyan
            print Rainbow("deflects #{armor_points} ").cyan
            print Rainbow("damage\n	     points. Its lifespan wanes.\n\n").cyan
        end
    end
    def character_damage
        if @alive
            SoundBoard.hit_character
            puts "	     Weapon Update:   #{@@player.print_character_damage}"
            puts "	     Critical Hit?:   #{Rainbow(weapon_is_weakness.to_s.capitalize).cyan}"
            print "	     Damage Result:   " ; print_damage
        end
    end
end


##############################################################################################################################################################################################################################################################
#####     MONSTERS     #######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Monster < Character
    def targets
        subtype | ["monster","beast","abomination","enemy","cryptid","demon"]
    end
    def special_behavior
        update_profile
        become_hostile if player_near
        #if chance == 1
            attack_player if @alive
        #else
            #special_move
        #end
    end
end


##############################################################################################################################################################################################################################################################
#####     ALTAR     ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Altar < Gamepiece
  attr_accessor :bone
  def initialize
    super
    @bone = bone
    @moveset = MOVES[1] | (MOVES[6] + MOVES[8]).flatten
    @lock_pick_stock = []
    @silver_ring_stock = []
    @gold_ring_stock = []
    @sneaker_stock = []
    @hoodie_stock = []
    @cane_stock = []
    @tonic_stock = []
    @juice_stock = []
    fill_stock
  end
  def fill_stock
    50.times do
      @lock_pick_stock.push(Lockpick.new)
      @silver_ring_stock.push(SilverRing.new)
      @gold_ring_stock.push(GoldRing.new)
      @sneaker_stock.push(Sneakers.new)
      @hoodie_stock.push(Hoodie.new)
      @cane_stock.push(Cane.new)
      @tonic_stock.push(Tonic.new)
      @juice_stock.push(Juice.new)
    end
  end
  def targets
    ["altar","shrine"]
  end
  def display_backdrop
    puts Rainbow("	   - You stand before a sinister").purple
    puts Rainbow("	     altar cut from black marble.\n").purple
  end
  def talk
    craft
  end
  def display_description
    puts Rainbow("	   - It towers up to your chest.").purple
    puts Rainbow("	     Your ears ring a little.\n").purple
    wrong_move
  end
  def craft
    print Rainbow("	   - You feel compelled to kneel.\n").red
    if any_materials? == true
        print Rainbow("	     The spirits offer a trade...\n\n").red
        crafting_menu
        print Rainbow("	   - Choose your worldly blessing\n").cyan
        print Rainbow("	     >> ").purple
        choice = gets.chomp.downcase.gsub(/[[:punct:]]/, '').split.last
        start_building(choice)
    else
        print Rainbow("	     You have nothing to offer.\n\n").red
    end
    print "	   - The altar releases you from\n"
    print "	     its grip. You stand up.\n\n"
  end
  def greedy_mortal_message
    print Rainbow("\n	   - Nothing comes from nothing.\n").red
    print Rainbow("	     You lack the materials.\n\n").red
  end
  def not_an_option
    print Rainbow("\n	   - The altar can only grant so\n").red
    print Rainbow("	     much. It can't craft that.\n\n").red
  end
  def lock_pick_materials?
    @@player.all_item_types.count(Key) > 1
  end
  def silver_ring_materials?
    @@player.all_item_types.count(Silver) > 1
  end
  def gold_ring_materials?
    @@player.all_item_types.count(Gold) > 1
  end
  def sneaker_materials?
    (@@player.all_item_types & [Rubber,Leather]).size == 2
  end
  def hoodie_materials?
    (@@player.all_item_types & [Silver,Silk]).size == 2
  end
  def cane_materials?
    (@@player.all_item_types & [Branch,Feather]).size == 2
  end
  def tonic_materials?
    (@@player.all_item_types & [Water,PurpleFlower]).size == 2
  end
  def juice_materials?
    (@@player.all_item_types & [Water,RedFlower]).size == 2
  end
  def any_materials?
    materials = [
      lock_pick_materials?,
      cane_materials?,
      tonic_materials?,
      juice_materials?,
      hoodie_materials?,
      sneaker_materials?,
      gold_ring_materials?,
      silver_ring_materials?,
      @@player.search_inventory(@bone)
    ].any?
  end
  def crafting_menu
    if lock_pick_materials?
      print(Rainbow("	     + 1 Lock Pick\n").green)
      print("	        - 2 Keys\n\n")
    end
    if silver_ring_materials?
      print(Rainbow("	     + 1 Silver Ring\n").green)
      print("	        - 2 Silver\n\n")
    end
    if gold_ring_materials?
      print(Rainbow("	     + 1 Gold Ring\n").green)
      print("	        - 2 Gold\n\n")
    end
    if sneaker_materials?
      print(Rainbow("	     + 1 Rubber Sneakers\n").green)
      print("	        - 1 Rubber\n")
      print("	        - 1 Leather\n\n")
    end
    if hoodie_materials?
      print(Rainbow("	     + 1 Spider Silk Hoodie\n").green)
      print("	        - 1 Silk\n")
      print("	        - 1 Silver\n\n")
    end
    if cane_materials?
      print(Rainbow("	     + 1 Magick Cane\n").green)
      print("	        - 1 Branch\n")
      print("	        - 1 Feather\n\n")
    end
    if tonic_materials?
      print(Rainbow("	     + 1 Exorcist Tonic\n").green)
      print("	        - 1 Holy Water\n")
      print("	        - 1 Purple Flower\n\n")
    end
    if juice_materials?
      print(Rainbow("	     + 1 Heart juice\n").green)
      print("	       - 1 Holy Water\n")
      print("	       - 1 Red Flower\n\n")
    end
    if @@player.search_inventory(@bone)
      print Rainbow("	   - You conquered your demon. To\n").pink
      print Rainbow("	     leave this level, simply ask\n").pink
      print Rainbow("	     for ").pink
      print Rainbow("salvation").blue
      print Rainbow(".\n\n").pink
    end
  end
  def build_item(stock, materials)
    print "\n"
    stock[0].take
    stock.shift
    materials.each { |material| delete_material(material) }
  end
  def build_lock_pick
    build_item(@lock_pick_stock, ["key","key"])
  end
  def build_silver_ring
    build_item(@silver_ring_stock, ["silver","silver"])
  end
  def build_gold_ring
    build_item(@gold_ring_stock, ["gold","gold"])
  end
  def build_sneakers
    build_item(@sneaker_stock, ["rubber","leather"])
  end
  def build_hoodie
    build_item(@hoodie_stock, ["silk","silver"])
  end
  def build_cane
    build_item(@cane_stock, ["branch","feather"])
  end
  def build_tonic
    build_item(@tonic_stock, ["water","purple flower"])
  end
  def build_juice
    build_item(@Juice_stock, ["water","red flower"])
  end
  def delete_material(material)
    @@player.items.find { |item| item.targets.include?(material) && @@player.remove_from_inventory(item) }
  end
  def start_building(choice)
    case choice
    when *@lock_pick_stock[0].targets
      lock_pick_materials? ? build_lock_pick : greedy_mortal_message
    when *@silver_ring_stock[0].targets
      silver_ring_materials? ? build_silver_ring : greedy_mortal_message
    when *@gold_ring_stock[0].targets
      gold_ring_materials? ? build_gold_ring : greedy_mortal_message
    when *@sneaker_stock[0].targets
      sneaker_materials? ? build_sneakers : greedy_mortal_message
    when *@hoodie_stock[0].targets
      hoodie_materials? ? build_hoodie : greedy_mortal_message
    when *@cane_stock[0].targets
      cane_materials? ? build_cane : greedy_mortal_message
    when *@tonic_stock[0].targets
      tonic_materials? ? build_tonic : greedy_mortal_message
    when *@Juice_stock[0].targets
      juice_materials? ? build_juice : greedy_mortal_message
    when "salvation", "ascension", "freedom", "transcend"
      level_complete_screen
    else
      not_an_option
    end
  end
  def wrong_move
    print "	   - A sacrificial altar can be\n"
    print Rainbow("	     prayed to" ).cyan + ", or "
    print Rainbow("examined").cyan + ".\n\n"
  end
end