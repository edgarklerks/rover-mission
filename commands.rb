# Commands, which moves the robot forward (with respect to the face)
class ForwardCommand
  def transform(old_coord)
    coord = Coordinate.clone(old_coord)
    xs = coord.face_as_unit_vector
    coord.x += xs[0]
    coord.y += xs[1]
    return coord
  end
  def to_s
    return "M"
  end
end

# Good for testing..
class BackwardCommand
  def transform(old_coord)
    coord = Coordinate.clone(old_coord)
    xs = coord.face_as_unit_vector
    coord.x -= xs[0]
    coord.y -= xs[1]
    return coord
  end
  def to_s
    return "?"
  end
end

# Commands, which turns the robot to the left with 90  degrees
class LeftCommand
  def transform(old_coord)
    coord = Coordinate.clone(old_coord)
    case coord.face
    when :N
      coord.face = :W
    when :W
      coord.face = :S
    when :S
      coord.face = :E
    when :E
      coord.face = :N
    end
    return coord
  end
  def to_s
    return "L"
  end
end

# Commands, which turns the robot to the right with 90  degrees
class RightCommand
  def transform(old_coord)
    coord = Coordinate.clone(old_coord)
    case coord.face
    when :N
        coord.face = :E
    when :E
      coord.face = :S
    when :S
      coord.face = :W
    when :W
      coord.face = :N
    end
    return coord
  end
  def to_s
    return "R"
  end
end
