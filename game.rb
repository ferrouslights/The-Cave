class Game
  ACTIONS = [
    :north, :east, :south, :west, :look, :fight, :take, :status
  ]

  def initialize
    @world = World.new
    @player = Player.new

    start_game
  end

  private
  def start_game
    while @player.alive?
      @current_room = @world.get_room_of(@player)

      print_status

      action = take_player_input
      next unless ACTIONS.include? action

      take_action(action)
    end
  end

  def take_player_input
    print "\n\nOptions:\nlook\nnorth\neast\nsouth\nwest\nfight\ntake\nstatus\n\nWhat do you want to do? =======> "
    gets.chomp.to_sym
  end

  def print_status
    puts "\nYou are at map coordinates [#{@player.x_coord}, #{@player.y_coord}]"

    puts @current_room
    if @current_room.content
      puts "You see #{@current_room.content}."
    end
  end

  def take_action(action)
    case action
    when :look
      print_status
    when :north
      @world.move_entity_north(@player)
    when :east
      @world.move_entity_east(@player)
    when :south
      @world.move_entity_south(@player)
    when :west
      @world.move_entity_west(@player)
    when :fight, :take
      @current_room.interact(@player)
    when :status
      @player.print_status
    end
  end
end
#PLAYER CLASS
class Player
  #attribute accessors
  attr_accessor :hit_points, :attack_power
  attr_accessor :x_coord, :y_coord

  #For resetting hp
  MAX_HIT_POINTS = 100

  #starts the game
  def initialize
    @hit_points        = MAX_HIT_POINTS
    @attack_power      = 1
    @x_coord, @y_coord = 0, 0
  end

  #checks if the player is alive
  def alive?
    @hit_points > 0
  end

  #for when the player takes damage
  def hurt(amount)
    @hit_points -= amount
  end

  #for when the player heals
  def heal(amount)
    @hit_points += amount
    @hit_points = [@hit_points, MAX_HIT_POINTS].min
  end

  #tells you the current status of the player
  def print_status
    puts "*" * 80
    puts "HP: #{@hit_points}/#{MAX_HIT_POINTS}"
    puts "AP: #{@attack_power}"
    puts "*" * 80
  end
end


#ITEM CLASS
class Item
  TYPES = [:potion, :poison, :sword, :battleaxe, :dagger]

  attr_accessor :type

  def initialize
    @type = TYPES.sample
  end

  def interact(player)
    case @type
    when :potion
      puts "You pick up #{self}."
      player.heal(10)
    when :poison
      puts "You pick up #{self}."
      player.hurt(10)
    when :sword
      puts "You pick up #{self}."
      player.attack_power += 3
    when :battleaxe
      puts "You pick up #{self}."
      player.attack_power += 5
    when :dagger
      puts "You pick up #{self}."
      player.attack_power += 1
    end
  end

  def to_s
    "a #{@type.to_s}"
  end
end



#MONSTER CLASS
class Monster
  attr_accessor  :hit_points, :attack_power

  #spawn health
  MAX_HIT_POINTS = 10

  #spawn
  def initialize
    @hit_points = MAX_HIT_POINTS
    @attack_power = 1
  end

  #checks to see if the monster is alive
  def alive?
    @hit_points > 0
  end

  #monster gets hurt
  def hurt(amount)
    @hit_points -= amount
  end

  #the announcement of the monster
  def to_s
    "a monster"
  end

  #player interactions
  def interact(player)
    while player.alive?
      puts "You hit the monster for #{player.attack_power} damage."
      hurt(player.attack_power)
      break unless alive?
      player.hurt(@attack_power)
      puts "The monster hits you for #{attack_power} damage"
    end
  end
end


#world building
class World
  WORLD_WIDTH = 10
  WORLD_HEIGHT = 100

#spawn the world
  def initialize
    @rooms = Array.new(WORLD_HEIGHT, Array.new(WORLD_WIDTH))
  end

#player movement and locations
  def move_entity_north(entity)
    entity.y_coord -= 1 if entity.y_coord > 0
  end

  def move_entity_south(entity)
    entity.y_coord += 1 if entity.y_coord < WORLD_HEIGHT - 1
  end

  def move_entity_east(entity)
    entity.x_coord += 1 if entity.x_coord < WORLD_WIDTH - 1
  end

  def move_entity_west(entity)
    entity.x_coord -= 1 if entity.x_coord > 0
  end

  def get_room_of(entity)
    @rooms[entity.x_coord][entity.y_coord] ||= Room.new
  end
end

#room spawn
class Room
  attr_accessor :size, :content

  def initialize
    @content   = get_content
    @size      = get_size
    @adjective = get_adjective
  end

  def interact(player)
    if @content
      @content.interact(player)
      @content = nil
    end
  end

  #room description
  def to_s
    "You are in a #{@size} room. It is #{@adjective}.\n"
  end

  private
  def get_content
    [Monster, Item].sample.new
  end

  def get_size
    ["small", "medium", "large", "narrow", "enormous"].sample
  end

  def get_adjective
    ["pretty", "ugly", "hideous", "horrendous and brutish",
      "elegant and pristine", "magnificent in architectural detail",
      "foul smelling", "filthy", "covered in old vines, as if noone
      has been here in a long time", "full of old dolls", "covered
      in old cobwebs", "old and shabby", "dilapidated and musty", "covered
      in mushrooms and smells of a strong mildew"].sample
  end
end

Game.new
