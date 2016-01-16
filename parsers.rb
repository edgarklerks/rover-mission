require_relative 'coordinates'

module Parsers
    class ParseError < RuntimeError
    end
    def self.isNatural(token)
        return token.match(/\A\d+\z/)
    end

    def self.parsePair(line)
        coords = line.split(' ')
        x = coords[0]
        y = coords[1]
        if ! isNatural(x)
          raise ParseError.new("Not a natural: #{x}")
        end

        if ! isNatural(y)
          raise ParseError.new("Not a natural #{x}")
        end

        return [[x.to_i,y.to_i], coords[2..-1].join(' ')]
    end

    def self.parseFace(p)
      case p
      when 'N'
        return :N
      when 'S'
        return :S
      when 'E'
        return :E
      when 'W'
        return :W
      else
        raise ParseError.new("Not a face")
      end
    end

    def parseBoundingBox(line)
      res = Parsers.parsePair(line)
      x = res[0][0]
      y = res[0][1]
      sp = Coordinate.new(0,0,:N)
      ep = Coordinate.new(x,y,:S)
      return RectangularBoundingBox.new(sp,ep)
    end

    def parseCoordinate(line)
        res = Parsers.parsePair(line)
        x = res[0][0]
        y = res[0][1]
        f = Parsers.parseFace(res[1])
        return Coordinate.new(x,y,f)
    end

    def parseCommands(line)
      commands = line.split('').map { | x |
        case x
        when 'L'
          LeftCommand.new
        when 'R'
          RightCommand.new
        when 'M'
          ForwardCommand.new
        else
          raise ParseError.new("Expected command: '#{x}'")
        end
      }
        return commands
    end

end
