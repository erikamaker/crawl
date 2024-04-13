##############################################################################################################################################################################################################################################################
#####    PRESETS    ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require_relative 'gamepiece'


##############################################################################################################################################################################################################################################################
#####    BRICKS    ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Bricks < Tiles
    def composition
  	    ["brick","bricks","block","blocks"]
    end
    def view_type
  	    puts "	   - The weathered bricks look to"
  	    puts "	     to be cut from solid rock.\n\n"
    end
    def view_wall
  	    puts "	   - The walls are built of bricks"
  	    puts "	     cobbled haphazardly together.\n\n"
    end
    def view_down
  	    puts "	   - The cobbled floor is stained"
  	    puts "	     with either soot or dirt.\n\n"
    end
    def view_above
  	    puts "	   - The cobbled ceiling is burnt"
  	    puts "	     black with torch smoke.\n\n"
    end
end

class Dungeon < Bricks
  def subtype
  	subtype = ["jail","dungeon","cell"]
  end
  def display_backdrop
  	puts "	   - You're in a cold prison cell."
  	puts "	     It's dark and mostly empty.\n\n"
  end
end

class Corridor < Bricks
  def subtype
  	subtype = ["tunnel","corridor","hall"]
  end
  def display_backdrop
  	puts "	   - You're in a cramped corridor"
  	puts "	     made of dark cobbled bricks.\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    ROCKS    ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class WarmRocks < Tiles
  def composition
  	composition = ["rock","rocks","geodes","earth","stone","stones"]
  end
  def view_type
  	puts "	   - The cavern walls radiate with"
  	puts "	     a pale green light somehow.\n\n"
  end
  def view_wall
  	puts "	   - The cave walls are smooth and"
  	puts "	     glimmer. They feel warm. \n\n"
  end
  def view_down
  	puts "	   - The cave floor's been eroded"
  	puts "	     smooth by the passing eons.\n\n"
  end
  def view_above
  	puts "	   - The cavern ceiling looms low"
  	puts "	     above your head.\n\n"
  end
end

class WarmCave < WarmRocks
  def subtype
  	subtype = ["cavern","cave","underground"]
  end
  def display_backdrop
  	puts "	   - You're in an ancient cavern."
  	puts "	     It's pleasantly warm.\n\n"
  end
end

class Grotto < WarmCave
  def subtype
  	subtype = ["cave","cavern","spring","pool","sauna","grotto"]
  end
  def display_backdrop
  	puts "	   - You're in a gleaming grotto"
  	puts "	     with a simmering spring.\n\n"
  end
  def view_above
  	puts "	   - The ceiling seems to yawn a"
  	puts "	     good 30 feet above you.\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    FIRE SOURCES    #####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Fire < Fixture
  def initialize
    super
  	@targets = subtype | ["fire","light","flame","flames"]
  end
end

class Fireplace < Fire
  def subtype
  	["fireplace", "grate", "coals", "coal", "hearth"]
  end
  def display_backdrop
  	puts "	   - Hot coals smolder in an iron"
  	puts "	     grate built into of the wall.\n\n"
  end
  def view
  	puts "	   - The coals glow and crackle.\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    TREE    #############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Tree < Fixture
    def targets
        ["tree","branch","branches","trunk","roots"]
    end
    def display_backdrop
        puts "	   - An ancient tree stands here,"
        puts "	     with huge gnarly roots.\n\n"
    end
    def view
        puts "	   - It's thick and marred by the"
        puts "	     eons it's withstood.\n\n"
        @@player.toggle_state_inert
    end
end


##############################################################################################################################################################################################################################################################
#####    HOOK    #############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Hook < Fixture
  def initialize
    super
    @targets = ["hook","rusty hook","metal hook"]
  end
  def display_backdrop
    puts "	   - A rusty hook juts out of the"
    puts "	     masonry where you stand.\n\n"
  end
  def view
    puts "	   - It looks sinister. Intuition"
    puts "	     tells you that demons use it"
    puts "	     to hang more than just coats"
    puts "	     and keys.\n\n"
    @@player.toggle_state_inert
  end
end


##############################################################################################################################################################################################################################################################
#####    SURFACES    #########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Surface < Fixture
  def initialize
    super
  	@targets = subtype | ["surface"]
  end
  def view
    subtype_view
    @@player.toggle_state_inert
  end
end

class Table < Surface
  def subtype
  	["table","stone table","tabletop"]
  end
  def display_backdrop
  	puts "	   - You stand before a humungous"
  	puts "	     table cut from solid rock.\n\n"
  end
  def subtype_view
  	puts "	   - Its rugged top rises to meet"
  	puts "	     you at your neck.\n\n"
  end
end

class Shelf < Surface
  def subtype
  	["shelf","wooden shelf"]
  end
  def display_backdrop
  	puts "	   - You stand at a wooden shelf."
  	puts "	     It's just within your reach.\n\n"
  end
  def subtype_view
    puts "	   - The wood is gnarly and blue."
  	puts "	     It's covered in scars.\n\n"
  end
end

class Grave < Surface
  def subtype
  	["grave","slab","gravestone","headstone"]
  end
  def display_backdrop
  	puts "	   - You stand before a headstone"
  	puts "	     sticking out of the ground.\n\n"
  end
  def display_inscription
    puts "	     The inscription has eroded.\n\n"
  end
  def subtype_view
  	puts "	   - It's made of crumbling rock."
    display_inscription
  end
end


##############################################################################################################################################################################################################################################################
#####    TOOLS     ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Lockpick < Weapon
  def initialize
    super
    @profile = {:build => "copper", :lifespan => 3, :damage => 2}
  end
  def subtype
    ["lock pick", "metal lock pick", "metal pick", "pick", "tool"]
  end
  def display_description
  	puts "	   - Maybe it belonged to another"
  	print "	     prisoner? It's quite sharp.\n\n"
  end
end

class Pickaxe < Weapon
  def initialize
    super
    @profile = {:build => "copper", :lifespan => rand(7..13), :damage => 3}
  end
  def subtype
    ["pickaxe","iron pickaxe"]
  end
  def display_description
    puts "	   - Trolls mine for precious ore"
  	puts "	     under the dungeon with these.\n\n"
  end
end

class Key < Tool
  def initialize
    super
    @profile = {:build => "brass", :lifespan => 1}
  end
  def subtype
    ["brass key", "key"]
  end
  def display_description
  	puts "	   - It's brittle and tarnished."
  	puts "	     It can be used just once.\n\n"
  end
end

class Match < Tool
  def equip
      burn = Rainbow("burn").cyan
      puts "	   - You cannot equip this tool."
      puts "	     Instead, use command #{burn}"
      puts "	     and select your target.\n\n"
  end
  def initialize
    super
    @profile = {:build => "wood", :lifespan => 1}
  end
  def subtype
    ["matchstick", "match"]
  end
  def display_description
  	puts "	   - It can only strike and light"
    puts "	     once, so choose wisely.\n\n"
  end
  def break_item
    if profile[:lifespan] == 0
        puts Rainbow("	   - You toss the expired match.\n").red
        @@player.remove_from_inventory(self)
        @@player.armor = nil
      end
  end
end


##############################################################################################################################################################################################################################################################
#####    WEAPONS    ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Hands < Weapon
    def initialize
      super
      @profile = { :build => "flesh", :lifespan => -1, :damage => @@player.level, :sigil => "None" }
    end
    def subtype
      ["bare hands","fists","hand","fist"]
    end
    def display_description
        puts "	   - Your own two hands. Wherever"
        puts "	     you reach, there they are.\n\n"
    end
    def equip
        @@player.weapon = self
    end
end

class Knife < Weapon
  def initialize
    super
    @profile = { :build => "bone", :lifespan => rand(5..10), :damage => 2, :sigil => "None" }
  end
  def subtype
    ["knife","dagger"]
  end
  def display_description
    puts "	   - It's a weak dagger made from"
  	puts "	     scrapped skeleton parts.\n\n"
  end
end

class Cleaver < Weapon
  def initialize
    super
    @profile = { :build => "iron", :lifespan => rand(10..15), :damage => 3, :sigil => "Evil"}
  end
  def subtype
    ["cleaver", "axe","blade"]
  end
  def display_description
    puts "	   - It's a butcher's cleaver. It"
  	puts "	     feels heavy in your hand.\n\n"
  end
end

class Sword < Weapon
  def initialize
    super
    @profile = { :build => "silver", :lifespan => rand(15..25), :damage => 4, :sigil => "Divinity" }
  end
  def subtype
    ["sword"]
  end
  def display_description
    puts "	   - It's a sturdy skeleton sword"
  	puts "	     infused with sacred silver.\n\n"
  end
end

class Cane < Weapon
  def initialize
    super
    @profile = { :build => "wood", :lifespan => rand(10..20), :damage => 5, :sigil => "Magick" }
  end
  def subtype
    ["hooked cane", "magick cane", "cane", "staff", "stave", "stick"]
  end
  def display_description
    puts "	   - A hooked cane's attack power"
    puts "	     grows with its user's level.\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    FOOD    #############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Bread < Edible
  def initialize
    super
  	@profile = { :hearts => 2, :portions => 3 }
  end
  def subtype
    ["bread loaf", "bread","loaf"]
  end
  def display_description
  	puts "	   - It's stale and burnt.\n\n"
  end
end

class Apple < Edible
  def initialize
    super
    @profile = { :hearts => 1, :portions => 3 }
  end
  def subtype
    ["apple"]
  end
  def display_backdrop
  	puts "	   - An indigo apple sits here.\n\n"
  end
  def display_description
  	puts "	   - Blue apples like these tend"
    puts "	     to grow underground.\n\n"
  end
end

class Mushroom < Edible
  def initialize
    super
    @profile = { :hearts => 4, :portions => 1, :effect => :entranced, :duration => 10 }
  end
  def subtype
    ["fungi","fungus","mushroom","shroom","toadstool","stool"]
  end
  def display_backdrop
    puts "	   - A small blue mushroom blooms"
    puts "	     on the wall here.\n\n"
  end
  def display_description
    puts "	   - Toadstools like these induce"
    puts "	     waking dreams when eaten.\n\n"
  end
  def side_effect
    puts "	     The walls begin to breathe."
    puts "	     Colors whirl in your eyes.\n\n"
    @@player.effect = :trance
  end
end


##############################################################################################################################################################################################################################################################
#####    FRUIT TREES    ######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class AppleSource < FruitSource
    def initialize
        super
        @type = Apple.new
        @profile = Apple.new.profile
    end
    def harvest_time
        @@page % 30 == 0
    end
    def push_stock
        @stock.push(Apple.new)
    end
    def subtype
        ["apple","apples"]
    end
end


##############################################################################################################################################################################################################################################################
#####    LIQUIDS    ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Water < Liquid
  def initialize
    super
    @profile = { :effect => :detoxification, :portions => 2}
  end
  def subtype
    ["water"]
  end
  def display_backdrop
    puts "	   - A vial of cherubim water sits"
    print "	     gleaming in the low light.\n\n"
  end
  def display_description
    puts "	   - It's water bottled by a rebel"
    puts "	     cherub. It exorcises curses.\n\n"
  end
  def activate_side_effects
    puts Rainbow("	   - A weight is lifted off your").cyan
    print Rainbow("	     back as the curse lifts.\n").cyan
    @@player.curse_clock = 1
  end
end

class Juice < Liquid
  def initialize
    super
  	@profile = { :effect => :stimulant, :portions => 3, :hearts => 2, :duration => 7}
  end
  def subtype
    ["juice","brew"]
  end
  def display_description
  	puts "	   - It's a vial of cherub juice for"
    puts "	     focus. It restores 2 hearts.\n\n"
  end
  def activate_side_effects
    puts Rainbow("	   - Your focus sharpens. Details").cyan
    print Rainbow("	     you've never noticed shimmer.\n\n").cyan
    @@player.smart += 7
  end
end

class Tonic < Liquid
  def initialize
    super
    @profile = { :effect => :analgesic, :portions => 2, :hearts => 2, :duration => 10 }
  end
  def subtype
    ["tonic","brew"]
  end
  def display_description
  	puts "	   - It's cherub tonic. It builds"
    puts "	     defense, and heals 2 hearts.\n\n"
  end
  def activate_side_effects
    puts Rainbow("	   - You feel light as a feather.").orange
    print Rainbow("	     Your defense begins to soar.\n").orange
    @@player.block_clock += 10
  end
end


##############################################################################################################################################################################################################################################################
#####    BURNABLES     #######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Torch < Burnable
  attr_accessor :content, :lit
  def initialize
      super
      @lit = true
  end
  def targets
    !@lit ? ["torch"] : ["torch", "fire", "flame"]
  end
  def moveset
      MOVES[1] | MOVES[9]
  end
  def remove_from_board
    light_torch
  end
  def special_behavior
      content.activate if @lit
  end
  def light_torch
      @lit = true
  end
  def douse_torch
      @lit = false
  end
  def unique_burn_screen
    if @lit
      puts "	   - The torch is already lit.\n"
    else
      puts Rainbow("	   - The cold base of the torch").orange
      puts Rainbow("	     lights and catches fire.\n").orange
      reveal_secret
    end
  end
  def describe_flame
      if @lit
          print "Its flame dances.\n\n"
      else
          print "It's gone cold.\n\n"
      end
  end
  def display_backdrop
      puts "	   - A black torch is bolted into"
      print "	     the wall. "
      describe_flame
  end
  def view
      puts "	   - It's an iron torch rivted to"
      print "	     the wall. "
      describe_flame
  end
end

class Blossom < Burnable
  def targets
    subtype | ["flower","blossom","plant","drug"]
  end
  def unique_burn_screen
    puts "	   - You hold the blossom against"
    puts "	     the fire, inhaling its smoke.\n\n"
    burn_effect
    remove_from_board
    @@player.remove_from_inventory(self)
    print "\n"
  end
end

class RedFlower < Blossom
  def initialize
    super
  	@profile = { :effect => :analgesic, :duration => 10}
  end
  def subtype
  	["red blossom","crimson","red flower","red"]
  end
  def display_description
  	puts "	   - When burned, it's a powerful,"
  	puts "	     but temporary pain reliever.\n\n"
  end
  def burn_effect
    puts Rainbow("	   - You feel light as a feather.").orange
    print Rainbow("	     Your defense begins to soar.\n").orange
    @@player.tough += 10
  end
end

class PurpleFlower < Blossom
  def initialize
    super
  	@profile = { :effect => :stimulant, :duration => 10}
  end
  def subtype
  	["purple flower","purple","violet","indigo"]
  end
  def display_description
    puts "	   - When burned, it's a powerful,"
    puts "	     but temporary stimulant.\n\n"
end
  def burn_effect
    puts Rainbow("	   - Your focus sharpens. Details").cyan
    print Rainbow("	     you've never noticed shimmer.\n").cyan
    @@player.focus_clock += 10
    self.remove_from_board
  end
end


##############################################################################################################################################################################################################################################################
#####    SILVER     ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Ore  < Portable
    def targets
      subtype | ["ore"]
    end
    def view
        puts "	   - It's valueless in Hell, but"
        puts "	     useful for crafting things.\n\n"
    end
end

class Silver < Ore
    def subtype
      ["silver ore", "silver"]
    end
    def display_backdrop
      puts "	   - A hunk of raw silver lays on"
      puts "	     the ground at your feet.\n\n"
    end
end

class Gold < Ore
    def subtype
      ["gold ore", "gold"]
    end
end



##############################################################################################################################################################################################################################################################
#####    FUEL     ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Fuel  < Portable
  def targets
    subtype | ["fuel","wax","fat","grease","oil"]
  end
end

class Fat < Fuel
  def subtype
    ["fat wad", "stinkworm fat"]
  end
  def view
    puts "	   - Stinkworm fat is putrid, but"
  	puts "	     good for refueling tanks.\n\n"
  end
end

class Wax < Fuel
  def subtype
    ["wax"]
  end
  def display_backdrop
    puts "	   - A wad of orange froths out of"
  	puts "	     the cave wall here.\n\n"
  end
  def view
    puts "	   - It's cave wax. Most commonly,"
  	puts "	     it's used to refuel tanks.\n\n"
  end
end

class Sap < Fuel
  def subtype
    ["sap","tree sap", "resin"]
  end
  def display_backdrop
    puts "	   - A drop of nearly-solid resin"
  	puts "	     hangs thick from the tree.\n\n"
  end
  def view
    puts "	   - It's a rich amber color, but"
  	puts "	     inedible. IT makes good fuel.\n\n"
  end
end



##############################################################################################################################################################################################################################################################
#####    CLOTHING MATERIAL     ###############################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Leather < Portable
  def targets
    ["leather","hide","skin"]
  end
  def display_backdrop
    puts "	   - The thick hide of a sewer rat"
  	puts "	     lays on the ground.\n\n"
  end
  def view
    puts "	   - It's durable leather. Usually,"
  	puts "	     it's used for crafting armor.\n\n"
  end
end

class Silk < Portable
  def targets
    ["silk","thread","web","webbing","webs"]
  end
  def display_backdrop
    puts "	   - A tangled mess of spider silk"
  	puts "	     webs the corner here.\n\n"
  end
  def view
    puts "	   - It's remarkably strong, and is"
  	puts "	     commonly used as thread.\n\n"
  end
end

class Rubber < Portable
  def targets
    ["rubber","silicone"]
  end
  def display_backdrop
    puts "	   - A durable chunk of raw rubber"
    puts "	     sulks on the ground here.\n\n"
  end
  def view
    puts "	   - You wonder where it came from,"
    puts "	     and what you can make with it.\n\n"
  end
end

class Bone < Portable
  def targets
    subtype | ["bone","fragment","scrap"]
  end
  def display_backdrop
    puts "	   - A dirty bone fragment lays at"
  	puts "	     your feet on the floor.\n\n"
  end
  def view
    puts "	   - It's a brittle base for tools"
  	puts "	     and weapons.\n\n"
  end
end

class Tusk < Bone
  def targets
    ["tusk","horn"]
  end
  def display_backdrop
    puts "	   - A heavy tusk fragment lays on"
  	puts "	     the ground here.\n\n"
  end
end

class Shell < Portable
  def targets
    ["shell"]
  end
  def display_backdrop
    puts "	   - A large spiral shell was shed"
  	puts "	     here. The snail's long gone.\n\n"
  end
  def view
    puts "	   - It is often crushed for brews"
  	puts "	     or elixers.\n\n"
  end
end

class Feather < Portable
  def targets
    ["feather","quill"]
  end
  def display_backdrop
    puts "	   - A dark, crooked raven's quill"
  	puts "	     lays on the floor here.\n\n"
  end
  def view
    puts "	   - It's used for crafting magick"
  	puts "	     staves, and sometimes potions.\n\n"
  end
end

class Ash < Portable
  def targets
    ["ash","ashes","charcoal","soot"]
  end
  def display_backdrop
    puts "	   - A small pile of ashes sits on"
  	puts "	     the ground here.\n\n"
  end
  def view
    puts "	   - It's the soot leftover from a"
  	puts "	     small woodfire. Brew with it.\n\n"
  end
end

class Branch < Burnable
  def initialize
    super
    @ash = Ash.new
  end
  def targets
    ["branch","stick","skin"]
  end
  def display_backdrop
    puts "	   - A fallen branch leans against"
  	puts "	     the tree's gnarled roots.\n\n"
  end
  def burn_effect
    @@player.items.delete(self)
    @ash.take
  end
  def unique_burn_screen
    puts Rainbow("	   - You hold the branch over the").orange
    puts Rainbow("	     flame. It smolders to ashes.\n").orange
    burn_effect
  end
  def view
    puts "	   - Made of hardy wood, it builds"
  	puts "	     magick staves. It is burnable.\n\n"
  end
end

class Gland < Portable
  def targets
    ["gland","ink"]
  end
  def display_backdrop
    puts "	   - A dark and spongy squid pouch"
  	puts "	     drips ink on the floor here.\n\n"
  end
  def view
    puts "	   - It's rubbery and fat with ink,"
  	puts "	     a common brewing component.\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    PLAYER'S BONES     ##################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################



class Femur < Bone
  def subtype
    ["femur"]
  end
  def display_backdrop
      puts "	   - A thick, crystal femur lays at"
      puts "	     your feet on the ground.\n\n"
  end
  def view
    puts "	   - It's your lost femur. Fetch it"
    puts "	     to the altar and ascend.\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    CLOTHES     #########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Clothes < Tool
  def targets
    subtype | ["clothing","clothes","garb","armor"]
  end
  def break_item
    if profile[:lifespan] == 0
      puts Rainbow("	   - Your #{targets[0]} completely degrades").red
      puts Rainbow("	     off your vulnerable body.\n").red
      @@player.remove_from_inventory(self)
      @@player.armor = nil
    end
  end
  def equip
    SoundBoard.equip_item
    self.push_to_player_inventory if @@player.items.none?(self)
    view
    puts Rainbow("	   - You put on the #{targets[0]}.").orange
    @@player.armor = self
  end
  def wrong_move
    print "	   - This clothing can be"
    print Rainbow(" examined").cyan + ",\n"
    print Rainbow("	     taken").cyan + ", or "
    print Rainbow("equipped").cyan + ".\n\n"
  end
end

class Rags < Clothes   # Requires 1 copper ore, and 3 spider spools
    def initialize
      super
      @profile = {:defense => 1, :lifespan => 30}
    end
    def subtype
      ["rags"]
    end
    def display_description
        puts "	   - It's a one-size set of rags, "
        puts "	     sewn with spider's silk.\n\n"
    end
    def equip
        @@player.armor = self
    end
  end

class Hoodie < Clothes   # Requires 1 copper ore, and 3 spider spools
  def initialize
    super
    @profile = {:defense => 2, :lifespan => 30}
  end
  def subtype
    ["hoodie","sweater","sweatshirt"]
  end
  def display_description
  	puts "	   - It's a hooded sweatshirt. It"
  	puts "	     was sewn with spider's silk.\n\n"
  end
end

class Cloak < Clothes   # Requires 1 copper ore, and 3 spider spools
  def initialize
    super
    @profile = {:defense => 3, :lifespan => 30}
  end
  def subtype
    ["cloak","robe","coat"]
  end
  def display_backdrop
    puts "	   - A dark and weighty cloak is"
    puts "	     hung on the wall here.\n\n"
  end
  def display_description
    puts "	   - It's a cloak. It was knitted"
    puts "	     from wool for a wizard.\n\n"
  end
end

class Sneakers < Clothes    # Requires 2 spider spools, 1 copper ore, and 4 rat leather
  def initialize
    super
    @profile = {:defense => 5, :lifespan => 50}
  end
  def subtype
    ["shoes","sneakers"]
  end
  def display_backdrop
    puts "	   - A pair of hide sneakers sits"
  	puts "	     untied on the ground.\n\n"
  end
  def display_description
  	puts "	   - They're cobbled from leather."
  	puts "	     Useful for dangerous terrain.\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    JEWELRY     #########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Jewelry < Portable
  def targets
    subtype | ["jewelry"]
  end
end

class Ring < Jewelry
  def subtype
    ["ring","band"]
  end
  def display_description
  	puts "	   - It fits. It doesn't do much,"
  	puts "	     but it sure is pretty.\n\n"
  end
end

class SilverRing < Ring  # Requires 1 silver
  def initialize
    @targets = ["ring","band"]
    @profile = {:build => "silver", :rune => "none"}
  end
  def display_backdrop
    puts "	   - A simple ring of silver sits"
  	puts "	     on the dirty ground.\n\n"
  end
end

class GoldRing < Ring  # Requires 1 silver
  def initialize
    @targets = ["ring","band"]
    @profile = {:build => "gold", :rune => "none"}
  end
  def display_backdrop
    puts "	   - A simple golden ring lays on"
  	puts "	     the dirty ground.\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    CONTAINERS    #######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Toilet < Container
  def targets
    ["drain","toilet","bowl","lid"]
  end
  def display_backdrop
  	puts "	   - A dirty lidded toilet sticks"
  	puts "	     out of the wall here.\n\n"
  end
end

class Chest < Container
  def initialize
    super
    @key = true
  end
  def targets
    ["chest","strongbox","lootbox","box"]
  end
  def display_backdrop
  	puts "	   - A wooden chest rests against"
  	puts "	     the dungeon wall.\n\n"
  end
end

class Urn < Container
  def initialize
    super
    @key = false
  end
  def targets
    ["urn","jar","bottle","remains"]
  end
  def display_backdrop
  	puts "	   - An ornate clay urn sits here.\n\n"
  end
end

class Barrel < Container
  def initialize
    super
    @key = false
  end
  def targets
    ["barrel","keg","drum","vat"]
  end
  def display_backdrop
  	puts "	   - A wooden barrel sits against"
  	puts "	     the wall here.\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    DOORS    ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Door < Container
  def initialize
    super
    @key = true
  end
  def special_behavior
    if state == :"already open"
      content.activate
    end
  end
  def give_content
    puts Rainbow("           - A new path is revealed. Your").cyan
    puts Rainbow("             map has been updated.\n ").cyan
    content.activate
    content.overview
    toggle_state_open
    SoundBoard.open_door
  end
  def targets
  	["door","exit"]
  end
  def display_backdrop
  	puts "	   - You stand near the threshold"
  	puts "	     of a heavy iron door.\n\n"
  end
  def wrong_move
    print "	   - This iron door can only be\n"
    print Rainbow("	     viewed").cyan + " or "
    print Rainbow("opened").cyan + ".\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####     PULL SWITCHES     ##################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Lever < Pullable
  def targets
    ["lever","handle","switch"]
  end
  def display_backdrop
  	puts "	   - An iron lever juts out from"
  	puts "	     the wall where you stand.\n\n"
  end
  def view
    unless @pulled
  	  puts "	   - This lever isn't pulled yet."
  	  puts "	     It could do anything.\n\n"
  	else
      puts "	   - It's stuck down and locked.\n\n"
  	end
  end
end

class Rope < Pullable
  def targets
    ["rope","twine","switch"]
  end
  def display_backdrop
    puts "	   - A frayed rope dangles above"
    puts "	     where you stand. It's huge.\n\n"
  end
  def view
  	unless @pulled
  	  puts "	   - It feels tied to something.\n\n"
  	else
      print "	   - It won't move any further.\n\n"
  	end
  end
end


##############################################################################################################################################################################################################################################################
#####    CHARACTERS     ######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Hellion < Monster
  attr_accessor :regions, :desires, :content, :rewards, :alive, :tough
  def initialize
    super
    @weapon = nil
    @armor = nil
    @tough = 0
    @rewards = RedFlower.new
    @desires = Match.new
    @health = 10
    @sigil = "Evil"
    @focus = 1
    @level = 1
    @weakness = "Magick"
  end
  def subtype
    ["hellion","goat"]
  end
  def docile_backdrop
    puts "	   - A dark hellion stands on two\n"
    puts "	     cloven hooves. It stinks.\n\n"
  end
  def hostile_backdrop
    puts "	   - A dark and violent hellion is"
    puts "	     stalking your every move.\n\n"
  end
  def display_description
    puts "	   - It's a hellion. This goatish"
    puts "	     demon has a quick temper.\n\n"
  end
end

class Goblin < Monster
    def initialize
      super
      @weapon = Knife.new
      @armor = Hoodie.new
      @rewards = [Bread.new,Hoodie.new]
      @desires = Match.new
      @profile = {:health => 8, :focus => 1}
    end
    def subtype
      ["goblin","imp","orc","yrch"]
    end
    def docile_backdrop
      puts "	   - A knobby goblin stoops near\n"
      puts "	     you in a black hoodie.\n\n"
    end
    def display_description
      puts "	   - It's a pallid-green goblin,"
      puts "	     about half your height.\n\n"
    end
end

  class Wizard < Character
    def initialize
      super
      @health = 8
      @tough = 0
      @focus = 1
      @defense = 0
      @sigil = "Magick"
      @weakness = "Evil"
      @weapon = Cane.new
      @rewards = Silver.new
      @armor = Cloak.new
      @desires = Gold.new
      @level = 0
    end
    def subtype
      ["wizard","caster","istari"]
    end
    def docile_backdrop
      puts "	   - A leathery old magick wizard\n"
      puts "	     stands here, lost in thought.\n\n"
    end
    def hostile_backdrop
        puts "	   - A wrathful wizard stalks you,\n"
        puts "	     his keen eyes glowing blue.\n\n"
    end
    def display_description
      puts "	   - It's a wizard. They are full"
      puts "	     of ancient power and wisdom.\n\n"
    end
  end