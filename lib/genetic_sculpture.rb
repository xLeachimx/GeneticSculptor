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
			x = rGen.rand(128) + rGen.rand
			y = rGen.rand(128) + rGen.rand
			z = rGen.rand(128) + rGen.rand
			@voxels[i] = Voxel.new(x,y,z)
		end
		@metrics = default_metrics;
		@metrics_calculated = false
	end

	def mutate
		rGen = Random.new
		changePoint = rGen.rand(@size)
		x = rGen.rand(128) + rGen.rand
		y = rGen.rand(128) + rGen.rand
		z = rGen.rand(128) + rGen.rand
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
		return if metrics_calculated
		@metrics[:spread] = spread
		@metrics[:spaceUse] = spaceUse
		@metrics[:duplicate] = duplicates
		@metrics[:phi] = phiRating
		metrics_calculated = true
	end

	def dominant compare
		if @metrics[:spread] <= compare.metrics[:spread] && @metrics[:spaceUse] >= compare.metrics[:spaceUse] &&
														    @metrics[:duplicate] <= compare.metrics[:duplicate] &&
														    @metrics[:phi] <= compare.metrics[:phi]
			return @metrics[:spread] < compare.metrics[:spread] || @metrics[:spaceUse]  > compare.metrics[:spaceUse] ||
														   		   @metrics[:duplicate] < compare.metrics[:duplicate] ||
														   		   @metrics[:phi] < compare.metrics[:phi]

		end
		return false
	end

	def comp compare
		return 1 if dominant(compare)
		return -1
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
		middleX = minMaxX[1] - minMaxX[0]
		middleY = minMaxY[1] - minMaxY[0]
		middleZ = minMaxZ[1] - minMaxZ[0]
		internalBox = BoundingBox.new(middleX, middleY, middleZ, width, height, depth)
		count = 0
		for v in @voxels
			count += 1 if internalBox.inside?(v)
		end
		return count/(@size-count)
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
		return (hw + dw + hd) - (3 * phi)
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
end