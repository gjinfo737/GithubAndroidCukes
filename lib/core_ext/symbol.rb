class Symbol
  def camelized_s
    self.to_s.split('_').map(&:capitalize).join
  end
end