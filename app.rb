$LOAD_PATH << './'
require 'ioc_container.rb'
require 'sword.rb'
require 'warrior.rb'
require 'pants.rb'

ioc = Ioc.new
ioc.bind(:weapon, Sword)
warrior = ioc.resolve(:warrior)
warrior.attack
