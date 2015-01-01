Voxel Class
===============
Fields
===============
* X-coordinate
* Y-coordinate
* Z-coordinate

===============
Methods
===============
* same?
  * input - Another Voxel
  * output - Boolean Value
  * description - Returns true iff the x, y, and z coordinates of both voxels are equivalent
* toSCAD
  * input - None
  * output - A string which is a valid line of OpenScad code
  * description - Allows conversion of voxel for using in an OpenScad script
* cross
  * input - Another Voxel
  * output - Two Voxels
  * description - "mates" two voxels and produces two mixed offspring