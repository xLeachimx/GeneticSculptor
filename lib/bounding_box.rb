class BoundingBox
	attr_accessor :x
	attr_accessor :y
	attr_accessor :z
	attr_accessor :width
	attr_accessor :height
	attr_accessor :depth

	def initialize x, y, z, width, height, depth
		@x = x
		@y = y
		@z = z
		@width = width
		@height = height
		@depth = depth
	end

	def intersect? bb
		return true if rangeIntersect?(minMax(@x,@width),minMax(bb.x,bb.width)) &&
					   rangeIntersect?(minMax(@y,@depth),minMax(bb.y,bb.depth)) &&
					   rangeIntersect?(minMax(@z,@height),minMax(bb.z,bb.height))
		return false
	end

	private

	def minMax origin, dimension
		min = origin - (dimension/2.0)
		max = origin + (dimension/2.0)
		return [min,max]
	end

	def insideRange? range, location
		return (location >= range[0] && location <= range[1])
	end

	def rangeIntersect? r1, r2
		return true if r2[0] < r1[0] && r2[1] >= r1[0]	
		return true if r2[0] >= r1[0] && r2[0] <= r1[1]
		return false
	end
end