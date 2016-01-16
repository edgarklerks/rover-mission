# A data type representing the coordinate system of the robot,
# which is (x,y,f) where x and y are integers
# and f is one of the four wind directions: n s w e
# The plane is retangular
class Coordinate
  attr_accessor :x
  attr_accessor :y
  attr_accessor :face

  def initialize(x,y,face)
    @x = x
    @y = y
    @face = face
  end

  # clone to watch out toppling over the edge by introducing side effects
  def self.clone(coord)
    new_coord = Coordinate.new(coord.x, coord.y, coord.face)
    return new_coord
  end

  def ==(other)
    @x == other.x and @y == other.y and @face == other.face
  end
  def to_s
    return "#{@x} #{@y} #{@face}"
  end

  # returns the face as a unit vector
  # Expects :N :S :E :W
  def face_as_unit_vector
    case @face
    when :N
       return [0,1]
    when :S
      return [0,-1]
    when :E
      return [1,0]
    when :W
      return [-1,0]
    end
  end
end

# A bounding box based on the coordinates above.
# TODO: I should make a small hierarchy out of it. Coordinate(x,y) > RobotCoordinate(x,y,face). It is ugly that I end up with an useless attribute.

class RectangularBoundingBox
  attr_accessor :start_coord
  attr_accessor :end_coord
  def initialize(start_coord, end_coord)
    @start_coord = start_coord
    @end_coord = end_coord
  end

  def ==(other)
    @start_coord == other.start_coord and @end_coord == other.end_coord
  end

  def in_bounds(new_coord)
       if      @start_coord.x <= new_coord.x \
               and @start_coord.y <= new_coord.y \
               and @end_coord.x >= new_coord.x \
               and @end_coord.y >= new_coord.y
                  return true
       end
       return false
  end
end
