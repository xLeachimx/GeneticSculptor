require_relative 'genetic_sculpture'
require 'gemetics'

def evaluatePopulation population
	population = population.sort{|x,y| x.comp(y)}
	for i in 0...population.size
		population[i].fitness = population.size - (i+1)
	end

	return population
end

def writeSculptureToFile sculpture

end

pop = Array.new(1000)
for i in 0...1000
	pop[i] = GeneticSculpture.new(100)
end

options = default_GA_options
options[:debug] = true

writeSculptureToFile runGeneticAlgorithm(pop, method( :evaluatePopulation ), 0, options)