require 'spec_helper'
RSpec.describe SproutSimulator::Plants::PlantReducer do
  context "harvest" do
    it "should not age dead plant" do

    end
    
    it "Harvest should do nothing right now" do
      expect(subject.harvest).to be_nil
    end
  end
end
