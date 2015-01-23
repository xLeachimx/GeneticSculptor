GeneticSculpture Class inherits GeneticObject
===============
Fields
===============
* Array of Voxels
* Fitness
* Class variable for number of voxels
* Hash of metrics
  * volume use >
  * Spread <
  * phi <

===============
Methods
===============
* mate
  * input - Another GeneticSculpture
  * output - Two GeneticSculptures
  * description - "mates" two sculptures and produces two mixed offspring
* toSCAD
  * input - None
  * output - A string which is a valid file of OpenScad code
  * description - Allows conversion of sculpture for use in an OpenScad script
* mutate
  * input - None
  * output - None
  * description - "mutates" organism through random replacement of a voxel with a random new voxel
* comp
  * input - Another GeneticSculpture
  * output - Boolean Value
  * description - Returns true iff each metric is even with or better than the given GeneticSculpture