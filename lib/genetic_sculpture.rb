require_relative 'voxel'

class GeneticSculpture
	attr_accessor :voxels
	attr_accessor :size

	def initialize size
		rGen = Random.new
		voxels = Array.new(@size)
		for i in 0...@size
			x = rGen.rand(128) + rGen.rand
			y = rGen.rand(128) + rGen.rand
			z = rGen.rand(128) + rGen.rand
			@voxels[i] = Voxel.new(x,y,z)
		end
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
	end
end