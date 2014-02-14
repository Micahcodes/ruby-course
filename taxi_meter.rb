class TaxiMeter
  attr_accessor :amount_due, :miles_driven, :mileage_cost, :waiting_time, :waiting_time_in_minutes
  attr_reader :start_time, :stop_time

  def initialize(amount_due=0, miles_driven=0)
    @amount_due = amount_due
    @miles_driven = miles_driven
    @miles_in_sixths = @miles_driven * 6.0
  end

  def start
    @start_time = Time.now
  end

  def stop
    @stop_time = Time.now
  end

  # calc mileage cost in cents
  def mileage_calc
    first_sixth_cost = 250
    each_sixth_cost = (@miles_driven * 6.0 - 1) * 240 / 6.0
    @mileage_cost = first_sixth_cost + each_sixth_cost
  end

  # calc wait time cost
  def waiting_time
    @waiting_time_in_minutes = (@meter.stop - @meter.start) / 60.0

    # @wait_cost = waiting_time_in_minutes * 2900.0 / 60.0
    # return @wait_cost
  end

  # calc total cost
  def amount_due
    @amount_due = self.mileage_calc
  end

end
