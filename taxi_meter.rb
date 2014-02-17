class TaxiMeter
  attr_accessor :amount_due, :miles_driven, :airport
  attr_reader :start_time, :stop_time

  def initialize
    @miles_driven = 0
    @amount_due = 0
  end

  def start
    @start_time = Time.now
  end

  def stop
    @stop_time = Time.now
  end

  def amount_due
    initial_cost = 250
    mileage_cost = 40 * (@miles_driven * 6.0 - 1)
    wait_cost = (Time.now - @start_time) / 60.0 * 2900.0 / 60.0
    current_due = (initial_cost + mileage_cost + wait_cost).round
  end

end
