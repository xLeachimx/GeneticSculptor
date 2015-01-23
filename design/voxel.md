Voxel Class
===============
Fields
===============
* X-coordinate
* Y-coordinate
* Z-coordinate
* shapeName
* height-z
* width-x
* depth-y

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

* volume
  * input - None
  * output - The volume of the solid
  * description - Returns the volume of the voxel