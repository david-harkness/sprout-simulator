module SproutSimulator::Plants
  # TODO: add global history of changed plants for debugging
  # Idea being, that nothing modifies internal state of a Plant.
  module PlantReducer
    # Define actions
    def self.adjust_settings(plant, hours:, intensity:, food:, water:)
      new_plant = plant.new_clone
      new_plant.health = new_plant.calculate_health(hours: hours, intensity: intensity, food: food, water: water)
      new_plant
    end

    def self.wait_for_tomorrow(plant)
      new_plant = plant.new_clone
      new_plant.age!
      new_plant
    end
  end
end
