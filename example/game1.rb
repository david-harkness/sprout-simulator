# Input Light Intensity, Light Duration, Food & water
# Plant health will change each day and grow based on health
# Menu code is mostly garbage
# Idea is to allow a large number of different plants to be managed.
# Using Reducer to allow for eventual parallelization of plant calculations

require "bundler/setup"
require "sprout_simulator"
require 'curses'
require './menu_methods'

include SproutSimulator::Plants

class ExampleGame
  attr_accessor :greenhouse

  def initialize(plants)
    @greenhouse = plants
  end

  # Anything alive?
  def some_plants_live?
    @greenhouse.any? { |plant| !plant.is_dead?}
  end

  def end_game_condition!
    MenuMethods.set_log_box("Everything in Greenhouse is dead. You have failed.")
    sleep 5
  end

  # Render each plant. (not going to scale well beyond 4 or so)
  def render_greenhouse
    @greenhouse.each_with_index do |plant, i|
      MenuMethods.show_plant_information(@greenhouse[i].to_s, 2 + i*12)
    end
  end

  def calculate_and_age_plants(answers)
    @greenhouse.each_with_index do |plant, index|
      plant             = PlantReducer.plant_with_new_health(plant, water: answers[:water], food: answers[:food], intensity: answers[:intensity], hours: answers[:hours])
      greenhouse[index] = PlantReducer.wait_for_tomorrow(plant)
    end
  end

  # Screen Setup and TearDown
  def setup_and_teardown
    begin
      MenuMethods.setup_screen
      MenuMethods.show_plant
      render_greenhouse
      yield
    ensure
      MenuMethods.teardown_screen
      puts "\n\tGame Over\n"
    end
    end_game_condition!
  end

  def play!
    setup_and_teardown do
      while some_plants_live?
        calculate_and_age_plants(MenuMethods.grab_input)
        sleep 0.5
        render_greenhouse
      end
    end
  end

end

# Our Collection of Plants
plants = [
    BambooPlant.new,
    BasicPlant.new,
    BambooPlant.new,
]

# Let's play a game
ExampleGame.new(plants).play!
