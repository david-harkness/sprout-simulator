require 'spec_helper'
RSpec.describe SproutSimulator::Plants::PlantReducer do
  context ""
  context "plant_with_new_health" do
    let(:bamboo) { SproutSimulator::Plants::BambooPlant.new }
    it "should have health of 60" do
      expect(bamboo.health).to eq(60)
    end
  end

  context "harvest" do
    it "should not age dead plant" do

    end

    it "Harvest should do nothing right now" do
      expect(subject.harvest).to be_nil
    end
  end
end
