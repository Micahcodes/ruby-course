class TaxiMeter
  attr_accessor :amount_due, :miles_driven, :airport
  attr_reader :start_time, :stop_time

  def initialize(airport: false)
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
    initial_cost = 250
    mileage_cost = 40 * (@miles_driven * 6.0 - 1)
    wait_cost = (Time.now - @start_time) / 60.0 * 2900.0 / 60.0
    current_due = (initial_cost + mileage_cost + wait_cost).round

    if @airport && current_due < 1310
      return 1310
    else
      if (Time.now.hour <= 4) || (Time.now.hour >= 21)
        return current_due + 100
      else
        return current_due
      end
    end
  end

end
