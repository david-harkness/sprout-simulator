module SproutSimulator::Plants
  # Base Class for other plants
  class BasicPlant
    attr :designation, :uuid
    attr_accessor :plant
    # attr_accessor :health, :height, :age, :branches # Future refactor

    def initialize(plant: {}, existing_uuid: nil) # ostruct would be nice
      @plant ||= OpenStruct.new(SproutSimulator::Plants::PlantDefaults.merge(plant))
      # For nowSet default on any missing variables
      # Later on, Sub classes should handle this, missing variables should throw an error
      @designation ||= 'Generic Plant'.freeze
      @uuid = SecureRandom.uuid if @uuid.nil?
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
    # #TODO: look at uuid it's probably broken
    def new_clone
      self.class.new(plant: @plant.to_h, existing_uuid: @uuid)
    end

    def plant_attributes
      @plant
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
