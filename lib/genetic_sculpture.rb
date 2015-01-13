require_relative 'voxel'
require_relative 'bounding_box'
require 'genetic_object'

def default_metrics
	return {
		spaceUse: 0,
		spread: 0,
		duplicate: 0,
		phi: 0,
	}
end

class GeneticSculpture < GeneticObject
	attr_accessor :voxels
	attr_accessor :size
	attr_accessor :metrics

	def initialize size
		@size = size
		rGen = Random.new
		@voxels = Array.new(@size)
		for i in 0...@size
			x = rGen.rand(100)
			y = rGen.rand(100)
			z = rGen.rand(100)
			@voxels[i] = Voxel.new(x,y,z)
		end
		@metrics = default_metrics
		@metrics_calculated = false
	end

	def mutate
		rGen = Random.new
		changePoint = rGen.rand(@size)
		x = rGen.rand(100)
		y = rGen.rand(100)
		z = rGen.rand(100)
		@voxels[changePoint] = Voxel.new(x,y,z)
	end

	def mate other
		rGen = Random.new
		crossPoint = rGen.rand(@size)
		one = GeneticSculpture.new(@size)
		two = GeneticSculpture.new(@size)
		for i in 0...crossPoint
			one.voxels[i] = @voxels[i]
			two.voxels[i] = other.voxels[i]
		end  

		for i in crossPoint...@size
			one.voxels[i] = other.voxels[i]
			two.voxels[i] = @voxels[i]
		end

		return [one, two]
	end

	def evalMetrics
		return if @metrics_calculated
		@metrics[:spread] = spread
		@metrics[:spaceUse] = spaceUse
		@metrics[:duplicate] = duplicates
		@metrics[:phi] = phiRating
		@metrics_calculated = true
	end

	def dominant compare
		if @metrics[:spread] <= compare.metrics[:spread] && @metrics[:spaceUse] >= compare.metrics[:spaceUse] &&
														    @metrics[:duplicate] <= compare.metrics[:duplicate] &&
														    @metrics[:phi] <= compare.metrics[:phi]
			if @metrics[:spread] < compare.metrics[:spread] || @metrics[:spaceUse]  > compare.metrics[:spaceUse] ||
														   	   @metrics[:duplicate] < compare.metrics[:duplicate] ||
														   	   @metrics[:phi] < compare.metrics[:phi]
				return 1
			else
				return 0
			end
		end
		return -1
	end

	def comp compare
		dominant(compare)
	end

	def toScad
		file = ""
		for v in @voxels
			file += v.toScad() + "\n"
		end
		return file
	end

	private

	def height
		minMax = minMaxY
		return minMax[1] - minMax[0]
	end

	def width
		minMax = minMaxX
		return minMax[1] - minMax[0]
	end

	def depth
		minMax = minMaxZ
		return minMax[1] - minMax[0]
	end

	def spread
		radius = 0
		if height() >= width() && height >= depth()
			radius = height
		elsif width() >= height() && width() >= depth()
			radius = width
		else
			radius = depth
		end

		radius = radius/2

		centerX = minMaxX[1] - minMaxX[0]
		centerY = minMaxY[1] - minMaxY[0]
		centerZ = minMaxZ[1] - minMaxZ[0]

		count = 0

		for v in @voxels
			count += 1 if distance(centerX, centerY, centerZ, v) < radius 
		end

		val = count-(@size/2)
		return val.abs
	end

	def spaceUse
		volume = height() * width() * depth()
		return @size/volume
	end

	def duplicates
		count = 0
		for v in @voxels
			for v2 in @voxels
				count += 1 if v.same?(v2)
			end
		end
		count -= @size
		return count
	end

	# Tests the bounding box for the presence of phi
	def phiRating
		phi = 1.61803398875
		hw = height()/width()
		dw = depth()/width()
		hd = height()/depth()
		val = (hw + dw + hd) - (3 * phi)
		return val.abs
	end

	# Methods for helping to calculate metrics

	def minMaxX
		highest = @voxels[0].x
		lowest = @voxels[0].x
		for v in @voxels
			if highest < v.x
				highest = v.x
			end

			if lowest > v.x
				lowest = v.x
			end
		end
		return [lowest,highest]
	end

	def minMaxY
		highest = @voxels[0].y
		lowest = @voxels[0].y
		for v in @voxels
			if highest < v.y
				highest = v.y
			end

			if lowest > v.y
				lowest = v.y
			end
		end
		return [lowest,highest]
	end

	def minMaxZ
		highest = @voxels[0].z
		lowest = @voxels[0].z
		for v in @voxels
			if highest < v.z
				highest = v.z
			end

			if lowest > v.z
				lowest = v.z
			end
		end
		return [lowest,highest]
	end

	def distance x, y, z, voxel
		dx = (x-voxel.x)**2 
		dy = (y-voxel.y)**2
		dz = (z-voxel.z)**2
		return Math.sqrt(dx+dy+dz)
	end
end