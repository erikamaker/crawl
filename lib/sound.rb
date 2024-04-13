##############################################################################################################################################################################################################################################################
#####    SOUND BOARD    ######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class SoundBoard
    def self.secret_music
      fork do
        exec('aplay ./sounds/secret.wav > /dev/null 2>&1')
      end
    end
    def self.found_item
      fork do
        exec('aplay ./sounds/found_item.wav > /dev/null 2>&1')
      end
    end
    def self.heal_heart
      fork do
        exec('aplay ./sounds/heal_heart.wav > /dev/null 2>&1')
      end
    end
    def self.open_door
      fork do
        exec('aplay ./sounds/open_door.wav > /dev/null 2>&1')
      end
    end
    def self.evil_laugh
      fork do
        exec('aplay ./sounds/evil_laugh.wav > /dev/null 2>&1')
      end
    end
    def self.wall_reveal
      fork do
        exec('aplay ./sounds/wall_reveal.wav > /dev/null 2>&1')
      end
    end
    def self.hit_enemy
      fork do
        exec('aplay ./sounds/hit_enemy.wav > /dev/null 2>&1')
      end
    end
    def self.select_move
      fork do
        exec('aplay ./sounds/select_move.wav > /dev/null 2>&1')
      end
    end
    def self.equip_item
      fork do
        exec('aplay ./sounds/equip_item.wav > /dev/null 2>&1')
      end
    end
    def self.take_damage
      fork do
        exec('aplay ./sounds/take_damage.wav > /dev/null 2>&1')
      end
    end
  end