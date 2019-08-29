module SproutSimulator::Plants
  # Base Class for other plants
  class BasicPlant
    DEFAULT_HEIGHT = 0
    DEFAULT_HEALTH = 50
    DEFAULT_AGE    = 0
    PLANT_NAME     = 'Basic Plant'

    attr :designation, :uuid
    attr_accessor :care
    attr_accessor :health, :height, :age, :branches

    def initialize(health: nil, age: nil, height: nil, existing_uuid: nil) # ostruct would be nice
      @care = OpenStruct.new(SproutSimulator::Plants::PlantDefaults)
      # For nowSet default on any missing variables
      # Later on, Sub classes should handle this, missing variables should throw an error
      @health = health || DEFAULT_HEALTH
      @height = height || DEFAULT_HEIGHT
      @age    = age    || DEFAULT_AGE
      @designation ||= PLANT_NAME
      @uuid ||= existing_uuid || SecureRandom.uuid
    end

    def grow!
      @height += calculate_growth
    end

    def age!
      @age += 1
      grow!
    end

    def is_dead?
      @health == 0
    end

    def calculate_growth
      ((@health / 100.0) * @care.max_growth_rate * random_growth).to_i
    end

    # Growth can be unpredictable
    def random_growth
      rand(0.75..1.25)
    end

    def to_s # Note: Move to a presenter
      %"#{@designation}: #{@uuid}\n #{_print_attributes}\n"
    end

    # For Reducer
    def new_clone
      self.class.new(health: @health, height: @height, age: @age, existing_uuid: @uuid)
    end

    # TODO: helper function, move elsewhere
    def percentage_diff(num1, num2)
      top = (num1 - num2).abs
      bottom = (num1 + num2) / 2.0
      top / bottom
    end

    private

    def _print_attributes # Note: Not a core function of class. Move to Presenter
      %| Health : #{is_dead? ? "Dead" : health.to_s + '%'}
  Height : #{height.to_f / 10 } centimeters
  Age    : #{age} days old|
    end
  end
end
