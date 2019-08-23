require 'pry'
module SproutSimulator::Plants
  module PlantCalculation

    # Calculate effect of care on a plant.
    def self.calculate_health(plant:, hours: 0, intensity: 0, food: 0, water: 0)
      duration = 1.0 - (hours - plant.care.ideal_light_hours).abs.to_f / plant.care.ideal_light_hours.to_f
      intensity_health = 1.0 - (intensity - plant.care.ideal_light_intensity).abs / plant.care.ideal_light_intensity.to_f

      # Intensity is twice as important, because why not.
      effect_percentage = (duration + (2 * intensity_health)) / 3.0
        + _calculate_water_effect(plant, water)
        + _calculate_food_effect(plant, food)
      _apply_health_modifier(plant.health, effect_percentage)
    end

    # Seeds need no food
    def self._calculate_food_effect(plant, food)
      ideal_food = plant.care.ideal_nutrients * plant.age
      return -0.3 if food < ideal_food
      return 0.1  if food >= ideal_food
    end

    # Water math is wonky, but not where I want to spend time
    # Basically water needs go up as plant gets taller
    def self._calculate_water_effect(plant, water)
      ideal_water = plant.care.ideal_water * [1, plant.height].max # 0 height is not sensible
      water_effect = water < ideal_water ? -0.1 : 0 #overly simple
      water_effect = -0.5 if water == 0
      water_effect = -0.1 if water > ideal_water * 20
      water_effect
    end

    def self._apply_health_modifier(health, effect)
      # puts effect
      adjust = case effect
               when -Float::INFINITY..(0.2)
                 -30
               when (0.2)..(0.4)
                 -10
               when (0.4)..(0.6)
                 0
               when (0.6)..(0.7)
                 2
               when (0.6)..(0.8)
                 5
               when (0.8)..(0.90)
                 10
               else
                 20
               end
      [0, health + adjust, 100].sort[1] # Refactor: Must health is between 0-100
    end

  end
end
