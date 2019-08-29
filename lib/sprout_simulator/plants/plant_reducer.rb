module SproutSimulator::Plants
  # TODO: add global history of changed plants for debugging
  # Idea being, that nothing modifies internal state of a Plant.
  module PlantReducer
    # Define actions
    def self.harvest
      # TODO:
    end

    def self.pesticide
      # TODO:
    end

    # New Plant with adjusted Health (unless dead)
    def self.plant_with_new_health(plant, hours:, intensity:, food:, water:)
      new_plant = plant.new_clone
      return new_plant if new_plant.is_dead? # No Zombie Plants
      new_plant.health = PlantCalculation.calculate_health(
          plant: plant, hours: hours, intensity: intensity, food: food, water: water
      )
      new_plant
    end

    # Age plant, unless dead
    def self.wait_for_tomorrow(plant)
      new_plant = plant.new_clone
      new_plant.age! unless plant.is_dead?
      new_plant
    end
  end
end
