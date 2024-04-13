
##############################################################################################################################################################################################################################################################
#####    DEPENDENCIES    #####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require_relative 'vocabulary'
require_relative 'interface'
require_relative 'board'
require_relative 'sound'
require_relative 'gamepiece'
require_relative 'presets'
require_relative 'player'


##############################################################################################################################################################################################################################################################
#####    LEVEL 1    ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################






# Adds each gamepiece and its unique qualities to record. Make your pieces tell a story.
# Portable items (loot) will display in list form following all room or fixture backdrop displays.


secret_room = Corridor.new
secret_room.location = [[0,3,2],[0,4,2],[0,5,2]]


torch_1 = Torch.new
torch_1.location = [[0,2,2]]
torch_1.douse_torch
torch_1.content = secret_room
def torch_1.reveal_secret
    SoundBoard.secret_music
    SoundBoard.wall_reveal
    puts Rainbow("	   - The eastern wall recedes to").cyan
    puts Rainbow("	     reveal a secret corridor.\n").cyan
    content.activate
end


room_1 = Dungeon.new
room_1.location = [[0,1,1],[0,1,2],[0,2,1],[0,2,2]]
room_1.instance_variable_set(:@torch_1, torch_1)     # A standard Ruby library method that lets us
def room_1.overview                                  # build interactions between different pieces.
    cond_1 = Board.player.pos == [0,2,2]
    cond_2 = Board.player.pos == [0,1,1]
    cond_3 = cond_1 || cond_2
    if !@torch_1.lit
        puts "	   - It's too dark to see anything"
        puts "	     past the current coordinate.\n\n"
        return
    end
    if Board.player.pos == [0,2,2]
        puts "	   - The torchlight fades in the"
        puts "	     east, swallowed by the murk.\n\n"
    end
    if !cond_3
        puts "	   - The cell is small. There's a"
        puts "	     stone drain in the northwest"
        puts "	     corner. A hidden tunnel near"
        puts "	     the opposite corner fades to"
        puts "	     black in the darkened east.\n\n"
    end
end


cane = Cane.new
cane.location = [[0,1,1]]
def cane.display_position
    puts "in the corner."
end

match = Match.new
match.location = [[0,1,1]]
def match.display_position
    puts "on the floor."
end

drain_1 = Toilet.new
drain_1.location =  [[0,1,1]]
drain_1.content = Lockpick.new

hall_1 = Corridor.new
hall_1.location = [[0,2,0],[0,2,-1],[0,2,-2]]
def hall_1.overview
  puts "	   - It's a narrow corridor south"
  puts "	     of your cell. A faint clang"
  puts "	     of metal striking metal can"
  puts "	     be heard to the southeast.\n\n"
end

door_1 = Door.new
door_1.location = [[0,2,1]]
door_1.content = hall_1

hook_1 = Hook.new
hook_1.location = [[0,2,0]]

hoodie_1 = Hoodie.new
hoodie_1.location = [[0,2,0]]
def hoodie_1.display_position
    puts "hangs from the hook."
end

room_2 = Dungeon.new
room_2.location = [[0,1,-3],[0,2,-3],[0,3,-3],[0,1,-4],[0,2,-4],[0,3,-4],[0,1,-5],[0,2,-5],[0,3,-5]]
def room_2.draw_backdrop
  puts "	   - You're in a homely guardroom."
  puts "	     It's warm, well-lit, and dry.\n\n"
end
def room_2.overview
  puts "	   - It's a cozy supply room where"
  puts "	     goblin guards eat and prepare"
  puts "	     to hunt. A warm fire roars in"
  puts "	     the western wall. A big table"
  puts "	     is set in the center.\n\n"
end

hellion_1 = Hellion.new
hellion_1.location = [[0,2,-1]]
hellion_1.regions = hall_1.location | room_2.location
def hellion_1.unique_bartering_script
  puts "	   - It asks if it can have yours,"
  print "	     in exchange for a secret.\n\n"
end
def hellion_1.reward_animation
  puts "	   - The hellion lowers its voice."
  puts "	     It barely whispers a rumor...\n\n"
  puts Rainbow("	   \" There's a third cell lost to").green
  puts Rainbow("	     the ages on this floor. \"\n").green
end
def hellion_1.default_script
  puts "	   - It leers at you, dark pupils"
  puts "	     flexing in its yellow eyes."
  puts "	     It says it lost its match.\n\n"
end
def hellion_1.passive_script
  puts "	   - It says this place isn't all"
  puts "	     that it seems. Be vigilant.\n\n"
end

chest_1 = Chest.new
chest_1.location = [[0,5,-4]]
chest_1.content = Knife.new

pull_1 = Lever.new
pull_1.location = [[0,3,-3]]
pull_1.content = chest_1
def pull_1.reveal_secret_text
  SoundBoard.secret_music
  puts Rainbow("	   - Something heavy crashes east").cyan
  print Rainbow("	     of the warm supply room.\n\n").cyan
end

door_2 = Door.new
door_2.location = [[0,2,-2]]
door_2.content = room_2

table_1 = Table.new
table_1.location = [[0,2,-4]]

bread_1 = Bread.new
bread_1.location =  [[0,2,-4]]

hall_2 = Corridor.new
hall_2.location = [[0,4,-4],[0,5,-4],[0,6,-4]]
def hall_2.overview
  puts "	   - It's a narrow hallway east of"
  puts "	     of the goblin supply chamber."
  puts "	     The clanging grows louder.\n\n"
end

door_3 = Door.new
door_3.location = [[0,3,-4]]
door_3.content = hall_2

pick_1 = Lockpick.new
pick_1.location = [[0,4,-4]]

fire_1 = Fireplace.new
fire_1.location = [[0,1,-4]]


tree = Tree.new
tree.location = [[0,1,1]]
apples = AppleSource.new
apples.location = [[0,1,1]]


altar = Altar.new
altar.location = [[0,1,2]]
altar.bone = Femur
def altar.level_complete_screen
    print "\e[?25l"
    system("clear")  # Clear the screen
    print "\n\n\n\n\n\n\n\n"
    sleep 2
    print Rainbow("	   - Your vision begins to fade.\n").violet
    print Rainbow("	     You're gently lifted away.\n\n").violet
    sleep 3
    print Rainbow("	   - But as you go, a whisper in\n").violet
    print Rainbow("	     your ear begin to grow.\n\n").violet
    sleep 3
    system("clear")  # Clear the screen
    sleep 3
    print Rainbow("\n\n\n\n\n\n\n\n	   \" You cannot outpace my abyss.\"\n\n\n\n\n\n\n" ).red.bright
    sleep 3
    print Rainbow("\n---------------------------------------------------------").blue.bright
    exit!
end


femur = Femur.new

fat1 = Fat.new
fat1.location = [[0,2,2]]
def fat1.display_position
    puts "sulks on the floor."
end

gold = Gold.new
gold.location = [[0,2,1]]
def gold.display_position
    puts "sits at your feet."
end

flower = RedFlower.new
flower.location = [[0,2,2]]
def flower.display_position
    puts "grows here."
end

flower2 = RedFlower.new
flower2.location = [[0,2,1]]
def flower.display_position
    puts "grows here."
end


juice = Juice.new
juice.location = [[0,2,1]]
def juice.display_position
    puts "sits on the floor."
end

wizard = Wizard.new
wizard.location = [[0,2,2]]
wizard.regions = hall_1.location | room_2.location | room_1.location

def wizard.unique_bartering_script
  puts "	   - He requests your gold. It's"
  print "	     very important he have it.\n\n"
end
def wizard.reward_animation
  puts "	   - The wizard whispers in your"
  print "	     ear, "
  print Rainbow("\'Luck be with you.\'\n\n").green
end
def wizard.default_script
  puts "	   - He says the dungeon stinks."
  puts "	     He's looking for a way out.\n\n"
end
def wizard.passive_script
  puts "	   - He says if you're ever lost,"
  puts "	     to always follow your nose.\n\n"
end


##############################################################################################################################################################################################################################################################
#####    GAME LOOP     #######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


rooms = [ room_1, door_1, door_2, door_3 ]
fixtures = [ torch_1, altar, drain_1, hook_1, pull_1, table_1, fire_1, tree, apples ]
npcs = [ wizard, hellion_1 ]
items = [ cane, juice, flower, gold, match, fat1, hoodie_1, bread_1 ]
loot = [ pick_1 ]





Board.run_level(rooms,fixtures,npcs,items,loot)


