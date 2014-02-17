require './taxi_meter.rb'
require 'pry-debugger'

describe TaxiMeter do

  def one_sixth
    1.0 / 6.0
  end

  describe "Basic functionality" do

    before do
      @meter = TaxiMeter.new
    end

    it "starts at zero" do
      @meter.amount_due = 0
      @meter.miles_driven = 0
    end

    it "can start and stop" do
      @meter.start
      expect(@meter.start_time).to_not be_nil
      expect(@meter.stop_time).to be_nil

      @meter.stop
      expect(@meter.stop_time).to_not be_nil
    end

    it "records the time it started" do
      # We want to freeze time to the point when the meter starts
      start_time = Time.now
      Time.stub(:now).and_return(start_time)

      # This should grab the current time
      @meter.start

      # Re-stub Time to be 5 minutes into the future
      Time.stub(:now).and_return(start_time + 5 * 60)

      # Once started, start_time shouldn't rely on the current time
      expect(@meter.start_time).to eq(start_time)
    end

    it "records the time it stopped" do
      #freeze time to the point when the meter stops
      stop_time = Time.now
      Time.stub(:now).and_return(stop_time)

      # this should grab the current time
      @meter.stop

      #re-stub Time to be 5min in the future
      Time.stub(:now).and_return(stop_time + 5 * 60)

      # once stopped, stop_time shouldn't rely on current time
      expect(@meter.stop_time).to eq(stop_time)
    end

  end

  context "The taxi meter starts" do
    before do
      # We want to freeze time to the point when the meter starts
      @seven_pm = Time.parse("2014-02-11 19:00:00 -0600")
      Time.stub(:now).and_return(@seven_pm)

      @meter = TaxiMeter.new
      @meter.start
    end

    it "charges $2.50 for the first 1/6 mile (recorded in cents)" do
      @meter.miles_driven = 1.0 / 6.0
      expect(@meter.amount_due).to eq(250)
    end

    it "charges correctly for 2 miles driven" do
      @meter.miles_driven = 2

      expect(@meter.amount_due).to eq(690)
    end
  end

  context "The taxi meter records waiting time" do
    before do
      @meter = TaxiMeter.new
      @seven_pm = Time.parse("2014-02-11 19:00:00 -0600")
      Time.stub(:now).and_return(@seven_pm)
    end

    it "checks the wait time" do
      # Copy/Paste previous start time test
      start_time = Time.now
      @meter.start
      Time.stub(:now).and_return(start_time + 60 * 60)
      @meter.stop

      expect(@meter.stop).to eq(start_time + 60 * 60)
    end

    it "checks the current cost" do
      @meter.start
      time = @seven_pm + (60 * 60)
      Time.stub(:now).and_return(time)

      expect(@meter.amount_due).to eq(3110)
    end

    it "charges additional dollar if start time between 9pm and 4am" do
      @three_am = Time.parse("2014-02-11 03:00:00 -0600")
      Time.stub(:now).and_return(@three_am)
      @meter.start
      new_time = @three_am + (40 * 60)
      Time.stub(:now).and_return(new_time)
      @meter.miles_driven = 10

      expect(@meter.amount_due).to eq(4643)
    end

    it "charges $29.00 an hour for waiting time, prorated by minute" do
      @seven_pm = Time.parse("2014-02-11 19:00:00 -0600")
      Time.stub(:now).and_return(@seven_pm)
      @meter.start
      time = @seven_pm + (40 * 60)
      Time.stub(:now).and_return(time)
      @meter.miles_driven = 10

      expect(@meter.amount_due).to eq(4543)
    end
  end

  context "The taxi meter starts from ABIA" do
    before do
      # We want to freeze time to the point when the meter starts
      @start_time = Time.now
      Time.stub(:now).and_return(@start_time)

      @meter = TaxiMeter.new(airport: true)
      @meter.start
    end

    it "has a minimum fare of $13.10" do
      time = @start_time + (2 * 60)
      Time.stub(:now).and_return(time)
      @meter.miles_driven = 2

      expect(@meter.amount_due).to eq(1310)
    end

  end

end
