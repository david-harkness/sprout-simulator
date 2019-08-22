module SproutSimulator::Plants
  class BambooPlant < BasicPlant
    def initialize(*args)
      @designation = 'Bamboo'.freeze
      super(*args)
      _setup_defaults
    end

    private

    # Maybe do this as a set of constants
    def _setup_defaults
      @plant.max_growth_rate = 200
      @plant.current_health = 30
      @plant.ideal_water = 20
      @plant.ideal_light_intensity = 9
      @plant.ideal_light_hours = 24
    end
  end
end
