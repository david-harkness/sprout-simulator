require 'sprout_simulator/plants/basic_plant'
require 'sprout_simulator/plants/plant_reducer'

module SproutSimulator::Plants
  # Poor man's type system
  # TODO: seperate fixed and dynamic attributes
  # Dynamic fields should be attributes on BasicPlant
  PlantAttributes = [
      :current_health,
      :current_height,
      :current_age,
      :current_live_branches,
      :current_dead_branches,
      :current_infestation,
      :max_growth_rate,
      :ideal_water,
      :ideal_nutrients,
      :ideal_light_intensity,
      :ideal_light_hours,
  ]
  # Future attributes
  #   :current_stage, enum "seed / sprout / plant / expired"
  #   ideal_container_size
  #   plant_sensitivity: 1 , # multiplier for poor management

  PlantDefaults = {
      current_health: 75, # range 0-100
      current_height: 0, # mm
      current_age: 0, # days
      current_live_branches: 0,
      current_dead_branches: 0,
      current_infestation: false,
      max_growth_rate: 20,
      ideal_water: 1.5 , # Amount of water needed per mm of plant
      ideal_nutrients: 0.05, # Ratio of food per mm of plant
      ideal_light_intensity: 5, # 1-10
      ideal_light_hours: 12,  # hours per plant
  }

  PlantActions = [
      :feed,
      :adjust_light_intensity,
      :adjust_light_hours,
      :water,
      :prune,
      :apply_pesticide,
      :destroy,
  ]
end
