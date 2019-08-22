require 'pry'
module SproutSimulator::Plants
  module PlantCalculation

    # TODO: move to reducer
    # TODO: should be NotImplemented. Let subclasses calculate
    # math probably needs work, this is business logic, define elsewhere
    def self.calculate_health(plant, health: health, hours: 0, intensity: 0, food: 0, water: 0)
      duration = 1.0 - (hours - plant.ideal_light_hours).abs.to_f / plant.ideal_light_hours.to_f
      intensity_health = 1.0 - (intensity - plant.ideal_light_intensity).abs / plant.ideal_light_intensity.to_f

      # Intensity is twice as important
      effect_percentage = (duration + (2 * intensity_health)) / 3.0 + _calculate_water_effect(plant, water)
      _apply_health_modifier(health, effect_percentage)
    end

    # Water math is wonky, but not where I want to spend time
    def self._calculate_water_effect(plant, water)
      ideal_water = plant.ideal_water * [1, plant.current_height].max # 0 height is not sensible
      water_effect = water < ideal_water ? -0.1 : 0 #overly simple
      water_effect = -0.5 if water == 0
      water_effect = -0.1 if water > ideal_water * 5
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
               when (0.8)..(0.95)
                 10
               else
                 20
               end
      [0, health + adjust, 100].sort[1] # Refactor: Must health is between 0-100
    end

  end
end
