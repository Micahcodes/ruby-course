class TaxiMeter
  attr_accessor :amount_due, :miles_driven, :airport
  attr_reader :start_time, :stop_time

  def initialize(airport = false)
    @miles_driven = 0
    @amount_due = 0
    @airport = airport
  end

  def start
    @start_time = Time.now
  end

  def stop
    @stop_time = Time.now
  end

  def amount_due
    # write if statements for all 5 parts of #4
    mileage_cost = 210 + (40 * @miles_driven * 6.0)
    wait_cost = (Time.now - @start_time) / 60.0 * 2900.0 / 60.0
    current_due = (mileage_cost + wait_cost).round

    if @airport = true && current_due < 1310
        return 1310
    else
      return current_due
    end

  end

end
