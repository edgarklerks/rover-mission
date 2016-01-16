class InputInteraction
  def interactive
    while true
      output = yield(n)
      print "#{output}\n"
    end
  end
end
