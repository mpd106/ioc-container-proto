class Warrior
  def initialize(weapon, pants)
    @weapon = weapon
    @pants = pants
  end

  def attack
    @weapon.use
  end

  def check_out_threads
    @pants.how_do_they_look
  end
end
