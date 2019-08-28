module SproutSimulator::Plants
  class BambooPlant < BasicPlant

    DEFAULT_HEIGHT = 0
    DEFAULT_HEALTH = 60
    DEFAULT_AGE    = 0

    def initialize(health: nil, age: nil, height: nil, existing_uuid: nil)
      @designation = 'Bamboo'
      super(health: health || DEFAULT_HEALTH, age: age, height: height, existing_uuid: existing_uuid)
      _override_care_defaults # Change Care Instructions # TODO: Refactor
    end

    private

    # Maybe do this as a set of constants
    def _override_care_defaults
      @care.max_growth_rate = 200
      @care.ideal_water = 2
      @care.ideal_light_intensity = 9
      @care.ideal_light_hours = 24
    end
  end
end
