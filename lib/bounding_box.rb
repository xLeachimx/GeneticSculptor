require_relative 'voxel'

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

	def inside? voxel
		return insideRange?(minMax(@x,@width), voxel.x) &&
			   insideRange?(minMax(@z,@depth), voxel.z) &&
			   insideRange?(minMax(@y,@height), voxel.y)
	end


	private

	def minMax origin, dimension
		min = origin - (dimension/2)
		max = origin + (dimension/2)
		return [min,max]
	end

	def insideRange? range, location
		return (location < range[0] || location > range[1])
	end
end