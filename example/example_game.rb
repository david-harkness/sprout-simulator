# Input Light Intensity, Light Duration, Food & water
# Plant health will change each day and grow based on health
# Menu code is mostly garbage
# Idea is to allow a large number of different plants to be managed.
# Using Reducer to allow for eventual parallelization of plant calculations

require "bundler/setup"
require "sprout_simulator"
require 'parallel'
require 'curses'
require './menu_methods'

include SproutSimulator::Plants

class ExampleGame
  attr_accessor :greenhouse

  def initialize(plants)
    @greenhouse = plants
  end

  def play!
    setup_and_teardown do
      while some_plants_live?
        # TODO: 50,000 objects?
        @greenhouse = calculate_and_age_plants(MenuMethods.grab_input)
        sleep 0.2
        MenuMethods.render_sun_motion
        render_greenhouse
      end
    end
  end

  private
  # Anything alive?
  def some_plants_live?
    @greenhouse.any? { |plant| !plant.is_dead?}
  end

  def end_game_condition!
    MenuMethods.set_log_box("All Plants are Dead.")
    sleep 2
  end

  # Render each plant. (not going to scale well beyond 4 or so)
  def render_greenhouse
    @greenhouse.each_with_index do |plant, i|
      MenuMethods.show_plant_information(@greenhouse[i].to_s, 2 + i*7)
    end
  end

  # TODO: delete
  # def calculate_and_age_plants(answers)
  #   @greenhouse.each_with_index do |plant, index|
  #     plant             = PlantReducer.plant_with_new_health(plant, water: answers[:water], food: answers[:food], intensity: answers[:intensity], hours: answers[:hours])
  #     greenhouse[index] = PlantReducer.wait_for_tomorrow(plant)
  #   end
  # end

  # TODO: code so 50,000 is not loaded all at once
  def calculate_and_age_plants(answers)
    results = Parallel.map(@greenhouse, in_processes: @greenhouse.count) do |old_plant|
      sleep 2
      tmp_plant             = PlantReducer.plant_with_new_health(old_plant, water: answers[:water], food: answers[:food], intensity: answers[:intensity], hours: answers[:hours])
      PlantReducer.wait_for_tomorrow(tmp_plant)
    end
    results # DELETE later
  end

  # Screen Setup and TearDown
  def setup_and_teardown
    begin
      MenuMethods.setup_screen
      render_greenhouse
      yield
    ensure
      MenuMethods.teardown_screen
      puts "#{SproutSimulator::Plants::PlantAsciiArt3}\n\n\t\tGame Over\n"
    end
    end_game_condition!
  end
end
