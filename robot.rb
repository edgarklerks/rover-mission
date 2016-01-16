require_relative 'coordinates'
require_relative "parsers"



# The robot has a simple interface,
# it can be initialized with its coordinates
# and then mission control can send commands to it
# however, the robot has a sense of self-preservation..
class Robot
  attr_accessor :coords
  attr_accessor :boundingbox

  def initialize(start_coord, boundary)
    @coords = start_coord
    @boundingbox = boundary
  end

  def to_s
    return "#{@coords}"
  end

  def run(commands)
    commands.each{ |c|
      move(c)
    }
    return self
  end

  private

  # TODO: this need to give back an exception if control is trying to drive the robot into oblivion
  def move(command)
    new_coords = command.transform(@coords)
    if @boundingbox.in_bounds(new_coords)
      @coords = new_coords
    end
  end
end
