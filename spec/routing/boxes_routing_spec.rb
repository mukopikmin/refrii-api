require "rails_helper"

RSpec.describe BoxesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/boxes").to route_to("boxes#index")
    end

    it "routes to #owns" do
      expect(:get => "/boxes/owns").to route_to("boxes#owns")
    end

    it "routes to #invited" do
      expect(:get => "/boxes/invited").to route_to("boxes#invited")
    end

    it "routes to #show" do
      expect(:get => "/boxes/1").to route_to("boxes#show", :id => "1")
    end

    it "routes to #units" do
      expect(:get => "/boxes/1/units").to route_to("boxes#units", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/boxes").to route_to("boxes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/boxes/1").to route_to("boxes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/boxes/1").to route_to("boxes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/boxes/1").to route_to("boxes#destroy", :id => "1")
    end

    it "routes to #invite" do
      expect(:post => "/boxes/1/invite").to route_to("boxes#invite", :id => "1")
    end

    it "routes to #deinvite" do
      expect(:delete => "/boxes/1/invite").to route_to("boxes#deinvite", :id => "1")
    end
  end
end
