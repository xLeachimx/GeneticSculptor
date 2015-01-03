class Voxel
	attr_accessor :x
	attr_accessor :y
	attr_accessor :z


	def initialize x, y, z
		@x = x
		@y = y
		@z = z
	end

	def same? other
		return other.x == @x and other.y == @y and other.z == z
	end

	def toSCAD
		return 'translate([' + @x + ',' + @y + ',' + @z + '])' + 'sphere(1)' 
	end

	def cross other
		which = Array.new(3)
		rGen = Random.new
		which[0] = (rGen.rand() > .5)
		which[1] = (rGen.rand() > .5)
		which[2] = (rGen.rand() > .5)
		one = other
		two = self
		if which[0]
			one.x = self.x
			two.x = other.x
		end
		if which[1]
			one.y = self.y
			two.y = other.y
		end
		if which[2]
			one.z = self.z
			two.z = other.z
		end
		return [one, two]
	end
end