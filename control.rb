require_relative 'coordinates'
require_relative "parsers"
require_relative "robot"
class Control
  include Parsers
  attr_accessor :commands
  attr_accessor :robots
  def initialize(msg)
    xs = msg.split("\n")
    bb = parseBoundingBox(xs[0])
    coord_rb1 = parseCoordinate(xs[1])
    commands_rb1 = parseCommands(xs[2])

    coord_rb2 = parseCoordinate(xs[3])
    commands_rb2 = parseCommands(xs[4])
    @commands = [commands_rb1, commands_rb2]
    @robots = [Robot.new(coord_rb1, bb), Robot.new(coord_rb2, bb)]
  end

  def start
    rb1 = @robots[0].run(@commands[0])
    print "#{rb1}\n"
    rb2 =  @robots[1].run(@commands[1])
    print "#{rb2}\n"
  end

end
