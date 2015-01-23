require_relative 'voxel'
require_relative 'bounding_box'
require 'genetic_object'

def default_metrics
	return {
		spaceUse: 0,
		spread: 0,
		phi: 0,
	}
end

class GeneticSculpture < GeneticObject
	attr_accessor :voxels
	attr_accessor :size
	attr_accessor :metrics

	def initialize size, limit
		@size = size
		@limit = limit
		rGen = Random.new
		@voxels = Array.new(@size)
		for i in 0...@size
			x = rGen.rand(@limit)
			y = rGen.rand(@limit)
			z = rGen.rand(@limit)
			shape = ['cube', 'cylinder', 'sphere'].sample
			height = rGen.rand(@limit/100.0)
			width = rGen.rand(@limit/100.0)
			depth = rGen.rand(@limit/100.0)
			@voxels[i] = Voxel.new(x,y,z,shape,height,width,depth)
		end
		@metrics = default_metrics
		@metrics_calculated = false
	end

	def mutate
		rGen = Random.new
		changePoint = rGen.rand(@size)
		x = rGen.rand(@limit)
		y = rGen.rand(@limit)
		z = rGen.rand(@limit)
		shape = ['cube', 'cylinder', 'sphere'].sample
		height = rGen.rand(@limit/100.0)
		width = rGen.rand(@limit/100.0)
		depth = rGen.rand(@limit/100.0)
		@voxels[changePoint] = Voxel.new(x,y,z,shape,height,width,depth)
	end

	def mate other
		rGen = Random.new
		crossPoint = rGen.rand(@size)
		one = GeneticSculpture.new(@size,@limit)
		two = GeneticSculpture.new(@size,@limit)
		cross = true
		for i in 0...@size
			cross = !cross if rGen.rand() < 0.25
			if cross
				one.voxels[i] = @voxels[i]
				two.voxels[i] = other.voxels[i]
			else
				one.voxels[i] = other.voxels[i]
				two.voxels[i] = @voxels[i]
			end
		end

		return [one, two]
	end

	def evalMetrics
		return if @metrics_calculated
		@metrics[:spread] = spread
		@metrics[:spaceUse] = spaceUse
		@metrics[:phi] = phiRating
		@metrics_calculated = true
	end

	def comp compare
		compMetr = compare.metrics
		if @metrics[:spread] <= compMet[:spread] && @metrics[:phi] <= compMet[:phi] && @metrics[:spaceUse] >= compMet[:spaceUse]
			if @metrics[:spread] < compMet[:spread] && @metrics[:phi] < compMet[:phi] && @metrics[:spaceUse] > compMet[:spaceUse]
				return 1
			end
			return 0
		end
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
		minMax = minMaxZ
		return minMax[1] - minMax[0]
	end

	def width
		minMax = minMaxX
		return minMax[1] - minMax[0]
	end

	def depth
		minMax = minMaxY
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

		radius = radius.to_f/2

		centerX = (width()/2.0) + minMaxX[0]
		centerY = (depth()/2.0) + minMaxY[0]
		centerZ = (height()/2.0) + minMaxZ[0]

		count = 0

		for v in @voxels
			count += 1 if distance(centerX.to_f, centerY.to_f, centerZ.to_f, v) < radius 
		end

		val = count-(@size.to_f/2)
		return val.abs
	end

	def spaceUse
		for v in @voxels
			volume += v.volume
		end
		return (@limit**3).to_f/volume
	end

	# Tests the bounding box for the presence of phi
	def phiRating
		phi = 1.61803398875
		hw = height().to_f/width()
		dw = depth().to_f/width()
		hd = height().to_f/depth()
		val = (hw + dw + hd) - (3 * phi)
		return val.abs
	end

	# Methods for helping to calculate metrics

	def minMaxX
		highest = @voxels[0].x + @voxels[0].width
		lowest = @voxels[0].x + @voxels[0].width
		for v in @voxels
			if highest < v.x + v.width
				highest = v.x + w.width
			end

			if lowest > v.x - v.width
				lowest = v.x - v.width
			end
		end
		return [lowest,highest]
	end

	def minMaxY
		highest = @voxels[0].y + @voxels[0].depth
		lowest = @voxels[0].y + @voxels[0].depth
		for v in @voxels
			if highest < v.y + v.depth
				highest = v.y + v.depth
			end

			if lowest > v.y - v.depth
				lowest = v.y - v.depth
			end
		end
		return [lowest,highest]
	end

	def minMaxZ
		highest = @voxels[0].z + @voxels[0].height
		lowest = @voxels[0].z + @voxels[0].height
		for v in @voxels
			if highest < v.z + v.height
				highest = v.z + v.height
			end

			if lowest > v.z - v.height
				lowest = v.z - v.height
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