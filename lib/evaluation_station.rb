require_relative 'genetic_sculpture'
require 'gemetics'

def evaluatePopulation population
	for p in population
		p.evalMetrics
	end
	population = population.sort{|x,y| x.metrics[:spread] <=> y.metrics[:spread]}
	for i in 0...population.size
		population[i].fitness = population.size - (i+1)
	end

	return population
end

def writeSculptureToFile sculpture
	f = File.new('best.scad', 'w')
	f.puts sculpture.toScad
	f.close
end

pop = Array.new(1000)
for i in 0...1000
	pop[i] = GeneticSculpture.new(100)
end

options = default_GA_options
options[:debug] = true
options[:genMax] = 10

writeSculptureToFile runGeneticAlgorithm(pop, method( :evaluatePopulation ), 100000, options)