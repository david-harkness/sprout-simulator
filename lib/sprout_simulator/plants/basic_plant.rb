module SproutSimulator::Plants
  # Base Class for other plants
  class BasicPlant
    attr :designation, :uuid
    attr_accessor :plant
    # attr_accessor :health, :height, :age, :branches # Future refactor

    def initialize(plant: {}, existing_uuid: nil) # ostruct would be nice
      @plant = OpenStruct.new(SproutSimulator::Plants::PlantDefaults.merge(plant))
      # For nowSet default on any missing variables
      # Later on, Sub classes should handle this, missing variables should throw an error
      @designation = 'Generic Plant'.freeze
      @uuid = SecureRandom.uuid if @uuid.nil?
    end

    # TODO: move to reducer
    # TODO: should be NotImplemented. Let subclasses calculate
    # math probably needs work, this is business logic, define elsewhere
    def calculate_health(hours: 0, intensity: 0, food: 0, water: 0)
      duration = 1.0 - (hours - @plant.ideal_light_hours).abs.to_f / @plant.ideal_light_hours.to_f
      intensity_health = 1.0 - (intensity - @plant.ideal_light_intensity).abs / @plant.ideal_light_intensity.to_f

      # Intensity is twice as important
      effect_percentage = (duration + (2 * intensity_health)) / 3.0 + _calculate_water_effect(water)
      _apply_health_modifier(effect_percentage)
    end


    # helper function, move elsewhere
    def percentage_diff(num1, num2)
     top = (num1 - num2).abs
     bottom = (num1 + num2) / 2.0
     top / bottom
    end

    def grow!
      @plant.current_height += calculate_growth
    end

    def age!
      @plant.current_age += 1
      grow!
    end

    def is_dead?
      health == 0
    end

    def calculate_growth
      ((@plant.current_health / 100.0) * @plant.max_growth_rate).to_i
    end

    def to_s # Note: Move to a presenter
      %"#{@designation}\n #{_print_attributes}\n"
    end

    # For Reducer
    def new_clone
      SproutSimulator::Plants::BasicPlant.new(plant: @plant.to_h, existing_uuid: @uuid)
    end

    def health=(val)
      @plant.current_health = val
    end

    def height
      @plant.current_height
    end

    def age
      @plant.current_age
    end

    def health
      @plant.current_health
    end

    private

    # Water math is wonky, but not where I want to spend time
    def _calculate_water_effect(water)
      ideal_water = @plant.ideal_water * [1, height].max # 0 height is not sensible
      water_effect = water < ideal_water ? -0.1 : 0 #overly simple
      water_effect = -0.5 if water == 0
      water_effect = -0.1 if water > ideal_water * 5
      water_effect
    end

    # TODO: move elsewhere
    def _apply_health_modifier(effect)
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

    def _print_attributes # Note: Not a core function of class. Move to Presenter
      %|
       Health : #{is_dead? ? "Dead" : health.to_s + '%'}
       Height : #{height.to_f / 10 } centimeters
       Age    : #{age} days old
      |
      # SproutSimulator::Plants::PlantAttributes.map do |ele|
      #   "\t #{@plant[ele]}\t #{ele}"
      # end.join("\n")
    end
  end
end
