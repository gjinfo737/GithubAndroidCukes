class Fixnum

  def in_millis
    self * 1000
  end

  def second
    self
  end

  def minute
    self * 60
  end

  def hour
    minute * 60
  end

  def day
    hour * 24
  end

  def week
    day * 7
  end

  alias_method :seconds, :second
  alias_method :minutes, :minute
  alias_method :hours, :hour
  alias_method :days, :day
  alias_method :weeks, :week
end
