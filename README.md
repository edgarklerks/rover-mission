# Rover mission #

I have choosen Ruby, because I couldn't choose my language of choice, however this had some consequences, because this is my first time ruby in say 10 years. So if things are unidiomatic, it is because of that.
I also couldn't wrap my head around gemspec, gemfile, rakefile and bundler.

For testing I used a behavioral driven approach, where I jotted down the behaviour of the code and let rantly generate testcases for me.


# Assumptions #

I have assumed there are exactly two robots.
I assumed that robots are ethereal and can pass each other.
I also assumed that the coordinates are naturals.

# Organisation #

* coordinate.rb
	* Contains all classes, which handle coordinates
* parsers.rb
	* Contains a module for parsing the robot message languagerite
* commands.rb
    * Contains command objects for the robot
	* It also contains a backward command for the tests.
* robot.rb
	* Contains the robot itself
	* The robot is responsible for processing commands and also responsible for keeping itself on the plateau.
* control.rb
	* Contains the control center.
	* Which is responsible for processing the message, initializing the robots and send them their commands.
* spec.rb contains all the tests


# Running the test suite #

First do:

	gem install rantly

then:

	rspec spec.rb
