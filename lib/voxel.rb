class Voxel
	attr_accessor :x
	attr_accessor :y
	attr_accessor :z
	attr_accessor :shape
	attr_accessor :height
	attr_accessor :width
	attr_accessor :depth


	def initialize x, y, z, shape, height, width, depth
		@x = x
		@y = y
		@z = z
		@shape = shape
		@height = height
		@width = width
		@depth = depth
	end

	def same? other
		fields = {
			x: @x,
			y: @y,
			z: @z,
			shape: @shape,
			height: @height,
			width: @width,
			depth: @depth
		}

		otherFields = {
			x: other.x,
			y: other.y,
			z: other.z,
			shape: other.shape,
			height: other.height,
			width: other.width,
			depth: other.depth
		}
		return fields == otherFields
	end

	def toScad
		base = 'translate([' + @x.to_s + ',' + @y.to_s + ',' + @z.to_s + '])'
		if @shape == 'cube'
			return base + 'cube(' + width + depth + height + ', center=true);'
		elsif @shape == 'cylinder'
			radius = (@width+@depth)/2
			return base + 'cylinder(' + 'h=' + @height + ',' + 'r= ' + radius + ',' +', center=true);'
		elsif @shape == 'sphere'
			radius = (@width + @height + @depth)
			return base + 'sphere(' + radius + ', center=true);'
		end
		return '//Problem with translation'
	end

	def volume
	end
end