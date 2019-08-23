require "bundler/setup"
require "sprout_simulator"
require 'curses'
require './menu_methods'

include Curses
include SproutSimulator::Plants

# Debug method
def test_without_graphics(plant)
  PlantReducer.wait_for_tomorrow(plant)
  plant = PlantReducer.adjust_settings(plant, water: 1, food: 0, intensity: 1, hours: 1)
  puts "Health #{plant.health}, Height #{plant.height}, Age, #{plant.age}, is_dead: #{plant.is_dead?}"

  plant = PlantReducer.adjust_settings(plant, water: 1, food: 0, intensity: 1, hours: 1)
  puts "Health #{plant.health}, Height #{plant.height}, Age, #{plant.age}, is_dead: #{plant.is_dead?}"
  exit
end

# Input Light Intensity, Light Duration, Food & water
# Plant health will change each day and grow based on health
# Menu code is mostly garbage
# lib/sprout_simulator is the more intersting code
# Idea is to allow a large number of different plants to be managed.
# Using Reducer to allow for eventual parallelization of plant calculations

# Main Loop
def get_settings_for_day(plant)
  MenuMethods.show_plant_information(plant.to_s)
  answers = MenuMethods.show_menu
  plant = PlantReducer.adjust_settings(plant, water: answers[:water], food: 0, intensity: answers[:intensity], hours: answers[:hours])
  PlantReducer.wait_for_tomorrow(plant)
end

# plant = BasicPlant.new
plant = BambooPlant.new

begin
  MenuMethods.setup_screen
  MenuMethods.show_plant_information(plant.to_s)
  while(true)
    # test_without_graphics(plant)
    plant = get_settings_for_day(plant)

    if plant.is_dead?
      MenuMethods.set_log_box("Plant is dead. You have failed.")
      sleep 5
      break
    end
    sleep 0.5
  end
ensure
  Curses.close_screen
end



# Testing Logic (comment out while loop), also move to rspec
# puts "Health #{plant1.health}, Height #{plant1.height}, Age, #{plant1.age}"
# puts '--'
# [0, 10, 50, 75, 100, 5].each do |health|
#   plant1.plant.current_health = health #bad way to do it
#   plant1.age! #less bad, but still bad
#   puts "Health #{plant1.health}, Height #{plant1.height}, Age, #{plant1.age}, is_dead: #{plant1.is_dead?}"
# end
#
# puts "\nPlant health 10,24"
# puts plant1.calculate_health(intensity: 10, hours: 24)
