require 'rspec'
require 'rantly'
require 'rantly/rspec_extensions'
require_relative 'coordinates'
require_relative 'commands'
require_relative 'robot'
require_relative 'parsers'
require_relative 'control'

RSpec.describe Coordinate do
  it "should preserve the coordinates" do
    property_of {
      x = integer
      y = integer
      f = choose(:N,:S,:E,:W)
      [x,y,f]
    }.check{ |x,y,f|
      coord = Coordinate.new(x,y,f)
      expect(coord.x == x).to be true
      expect(coord.y == y).to be true
      expect(coord.face == f).to be true
    }
  end
  it "should translate the face as unit vector correctly" do
    property_of {
      x = integer
      y = integer
      f = choose :N,:S,:E,:W
      [x,y,f]
    }.check{ |x,y,f|
      coord = Coordinate.new(x,y,f)
      case coord.face
      when :N
        expect(coord.face_as_unit_vector == [0,1]).to be true
      when :S
        expect(coord.face_as_unit_vector == [0,-1]).to be true
      when :E
        expect(coord.face_as_unit_vector == [1,0]).to be true
      when :W
        expect(coord.face_as_unit_vector == [-1,0]).to be true
      end
    }
  end
  it "should be the same under a left after right command (and vice versa" do
    property_of {
      x = integer
      y = integer
      f = choose :N,:S,:E,:W
      [x,y,f]
    }.check{ |x,y,f|
      coord = Coordinate.new(x,y,f)
      lft = LeftCommand.new
      rgt = RightCommand.new
      expect(lft.transform(rgt.transform(coord)) == coord).to be true
      expect(rgt.transform(lft.transform(coord)) == coord).to be true
    }
  end

  it "should be the same coordinate when moving backward and format" do
  property_of {
    x = integer
    y = integer
    f = choose :N,:S,:E,:W
    [x,y,f]
  }.check{ |x,y,f|
      coord = Coordinate.new(x,y,f)
      fw = ForwardCommand.new
      bw = BackwardCommand.new
      expect(fw.transform(bw.transform(coord)) == coord).to be true
      expect(bw.transform(fw.transform(coord)) == coord).to be true

  }
  end
end

RSpec.describe RectangularBoundingBox do

  it "should be able to tell if the coordinate is within the box" do
    property_of {
      xr = integer
      yr = integer

      guard xr > 0
      guard yr > 0
      [xr,yr]
    }.check{ |x,y|
      lp = Coordinate.new(0,0,:N)
      rp = Coordinate.new(x,y,:S)
      bb = RectangularBoundingBox.new(lp,rp)
      expect(bb.in_bounds(Coordinate.new(1,1,:S))).to be true
      expect(bb.in_bounds(Coordinate.new(1,0,:S))).to be  true
      expect(bb.in_bounds(Coordinate.new(0,1,:S))).to be  true
      expect(bb.in_bounds(Coordinate.new(0,0,:S))).to be true

      expect(bb.in_bounds(Coordinate.new(-1,-1,:S))).to be false
      expect(bb.in_bounds(Coordinate.new(-1,0,:S))).to be false
      expect(bb.in_bounds(Coordinate.new(x-1,y-1,:S))).to be true
      expect(bb.in_bounds(Coordinate.new(x-1,y,:S))).to be true
      expect(bb.in_bounds(Coordinate.new(x,y-1,:S))).to be true

      expect(bb.in_bounds(Coordinate.new(x+1,y+1,:S))).to be false
      expect(bb.in_bounds(Coordinate.new(x,y+1,:S))).to be false
      expect(bb.in_bounds(Coordinate.new(x+1,y,:S))).to be false
    }
  end

end

RSpec.describe Parsers do
  let(:parseClass) { Class.new{extend Parsers}}
  it "should parse pair Coordinates correctly" do
    property_of {
      x = integer
      y = integer
      f = choose(:N,:S,:E,:W)
      guard x > 0
      guard y > 0
      [x,y,f]
    }.check{ |x,y,f|
      coord = parseClass.parseCoordinate("#{x} #{y} #{f}")
      coord_certain = Coordinate.new(x,y,f)
      expect(coord == coord_certain).to be true
    }
  end

    it "should parse a bounding box correctly" do
      property_of {
        xr = integer
        yr = integer
        guard xr >= 0
        guard yr >= 0
        [xr,yr]
      }.check { |xr,yr|
        bb = parseClass.parseBoundingBox("#{xr} #{yr}")
        sp = Coordinate.new(0,0,:N)
        ep = Coordinate.new(xr, yr, :S)
        bb_certain = RectangularBoundingBox.new(sp,ep)
        expect(bb == bb_certain).to be true

      }
    end

    it "should parse a stream of commands correctly" do
      property_of {
       xs = array(10) { choose(RightCommand.new, LeftCommand.new, ForwardCommand.new)}
       xs
      }.check { |cs|
        as_string = cs.map { |x| x.to_s }.join
        cmds = parseClass.parseCommands(as_string)
        as_string_certain = cmds.map { |x| x.to_s }.join
        expect(as_string == as_string_certain).to be true
      }
    end

end

RSpec.describe Control do
  let (:msg) { "5 5\n1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM" }
  it "should do the examples correctly" do
    ctrl = Control.new(msg)
    ctrl.start()
  end
end
