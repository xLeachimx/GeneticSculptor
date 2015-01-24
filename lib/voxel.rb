require_relative 'bounding_box'

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
			return base + 'cube(' + @width.to_s + ',' + @depth.to_s + ',' + @height.to_s + ', center=true);'
		elsif @shape == 'cylinder'
			radius = (@width+@depth)/2.0
			return base + 'cylinder(' + 'h=' + @height.to_s + ',' + 'd= ' + radius.to_s + ', center=true);'
		elsif @shape == 'sphere'
			radius = (@width + @height + @depth)/3.0
			return base + 'sphere(d=' + radius.to_s + ', center=true);'
		end
		return '//Problem with translation'
	end

	def volume
		if @shape == 'cube'
			return @width*@height*@depth
		elsif @shape == 'cylinder'
			radius = (@width+@depth)/2.0
			return @height*Math::PI*((radius/2)**2)
		elsif @shape == 'sphere'
			radius = (@width+@depth+@height)/3.0
			return (4.0/3.0)*Math::PI*((radius/2)**3)
		end
		return -1
	end

	def intersect? other
		return boundingBox().intersect?(other.boundingBox())
	end

	def boundingBox
		if @shape == 'cube'
			return BoundingBox.new(@x,@y,@z,@width,@height,@depth)
		elsif @shape == 'cylinder'
			radius = (@width+@depth)/2.0
			return BoundingBox.new(@x,@y,@z,radius,@height,radius)
		elsif @shape == 'sphere'
			radius = (@width + @height + @depth)/3.0
			return BoundingBox.new(@x,@y,@z,radius,radius,radius)
		end
		return nil
	end
end