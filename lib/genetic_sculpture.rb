require_relative 'voxel'

default_metrics = {
	volume: 0,
	spaceUse: 0,
	spread: 0,
	duplicate: 0,
}

class GeneticSculpture
	attr_accessor :voxels
	attr_accessor :size
	attr_accessor :metrics

	def initialize size
		rGen = Random.new
		voxels = Array.new(@size)
		for i in 0...@size
			x = rGen.rand(128) + rGen.rand
			y = rGen.rand(128) + rGen.rand
			z = rGen.rand(128) + rGen.rand
			@voxels[i] = Voxel.new(x,y,z)
		end
		@metrics = default_metrics;
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
		@metrics[:spread] = spread
		@metrics[:volume] = height() * width() * depth()
		@metrics[:spaceUse] = spaceUse
		@metrics[:duplicate] = duplicates
	end

	def compareMetrics comp
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
	end

	def spaceUse
	end

	def duplicates
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