require_relative 'genetic_sculpture'
require 'gemetics'

def evaluatePopulation population
	for p in population
		p.evalMetrics
	end
	population = population.sort{|x,y| x.comp(y)}
	size = population.size
	for i in 0...population.size
		population[i].fitness = (size - i)
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
	pop[i] = GeneticSculpture.new(100, 1000)
end

options = default_GA_options
options[:debug] = true
options[:genMax] = 10000
options[:totalPopReplace] = false
options[:mutationPercent] = 0.1

writeSculptureToFile runGeneticAlgorithm(pop, method( :evaluatePopulation ), 1005, options)
