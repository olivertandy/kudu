# kudu
Generates animated particle systems.

![Example](/example.png)

The goal was to come up with a class structure that could produce as general a set of geometric patterns as possible. All animation paths are continually cycled; the intention for the program's evolution is ultimately to provide the basis for a visual accompaniment to music.

## Structure
Kudu generates particle systems whose attributes are defined by the 'envelopes' in the control panels on the left and right. The basic geometry of each system consists of 2 layers of paths:

![Structure](/structure.png)

There is a single parent path ('Layer 1'), along which several child paths are positioned ('Layer 2'), and then finally along these paths are displayed the particles. Variations on position, colour, etc. change according to where the particle is situated on its parent path and in time. How the aspects vary can be altered using the control grids to the left and right of the image.

## Interaction
Left-clicking and right-clicking on each individual cell in a control grid will scroll backward and forward respectively through the preset envelope shapes, which define how the attributes (corresponding to the rows of the control grids) change with various aspects of where the particle is situated (corresponding to the columns). All the envelopes are initially defaulted a constant value of 1.

## Description of files
### kudu.pde
Contains the main animation loop and defines preset shapes. The shapes used as the basis for the particles/paths are currently defined here.
### sceneGraph.pde
The class that defines the tree structure for paths and particles. Since particles and paths can both be inserted into the same points of the SceneGraph tree, the nesting of paths-placed-along-paths is extensible. The main program currently uses only 2 'layers' of path.
### spreadParticle.pde
The class that stores the shape data for both paths and particles and their respective attributes.
### attributes.pde
Class that manages the dependent attributes, applying transformations according to the envelope set in the control grid.
### bezier.pde
Implementation of a Bezier curve.
### envelope.pde
Class that defines an envelope to be set in the control grid. Stores pre-calculated values of a function at a discrete set of points, and when called to give a value, approximates the value at any given point by linear interpolation. This method may seem superfluous for standard functions but was intended to allow for randomly generated functions and point-wise editing of envelopes in future iterations.
### envelopeMatrix.pde
Stores the set of envelopes for a given control grid.
### grid.pde
A grid object that handles drawing and detection of mouse position.
### lambda.pde
Implementation of functions-as-objects, for use with the envelope class when creating a new envelope.

## Running the code
Kudu should be straightforward to run via the Processing IDE. It requires the Geomerative library (https://github.com/rikrd/geomerative) to be installed.
