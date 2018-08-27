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
    @hit_points = [@hit_points, MAX_HIT_POINTS]
  end

  def print_status
    puts "*" * 80
    puts "HP: #{@hit_points}/#{MAX_HIT_POINTS}"
    puts "AP: #{@attack_power}"
    puts "*" * 80
  end
end
