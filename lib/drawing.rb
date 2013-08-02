module Drawing

  def draw_a_box(info={:x => 100, :y => 200, :width => 100, :height => 100})
    location = {:x => info[:x], :y => info[:y]}
    width = info[:width]
    height = info[:height]
    location = left_to_right(location, width)
    location = top_to_bottom(location, height)
    location = right_to_left(location, width)
    location = bottom_to_top(location, height)
    location = top_left_to_bottom_right(location, width,  height)
    location
  end
    
  def top_left_to_bottom_right(coordinate, width, height)
    x, y = point_from(coordinate)
    drag x, x + width, y, y+height
    coordinate[:x] += width
    coordinate
  end
  
  def left_to_right(coordinate, width)
    x, y = point_from(coordinate)
    drag x, x + width, y, y
    coordinate[:x] += width
    coordinate
  end

  def right_to_left(coordinate, width)
    x, y = point_from(coordinate)
    drag x, x - width, y, y
    coordinate[:x] -= width
    coordinate
  end

  def top_to_bottom(coordinate, height)
    x, y = point_from(coordinate)
    drag x, x, y, y + height
    coordinate[:y] += height
    coordinate
  end

  def bottom_to_top(coordinate, height)
    x, y = point_from(coordinate)
    drag x, x, y, y - height
    coordinate[:y] -= height
    coordinate
  end

  def point_from(coordinate)
    [coordinate[:x], coordinate[:y]]
  end

  def drag(start_x, end_x, start_y, end_y)
    platform.drag(start_x.to_f, end_x.to_f, start_y.to_f, end_y.to_f, 1)
  end
end