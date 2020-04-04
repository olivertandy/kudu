# kudu
Generates animated particle systems according to a nested path structure. All animation paths are continually cycled; the intention for the program is to provide the basis for a visual accompaniment to music.

## Structure
Kudu generates particle systems whose attributes are defined by the 'envelopes' in the control panels on the left and right. The basic geometry of each system consists of 2 layers of paths:

![Structure](/structure.png)

There is a single parent path ('Layer 1'), along which several child paths are positioned ('Layer 2'), and then finally along these paths are displayed the particles. Variations on position, colour, etc change according to where the particle is situated on its parent path and in time. How the aspects vary can be altered using the control grids to the left and right of the image.

## Interaction
Left-clicking and right-clicking on each individual cell will scroll backward and forward respectively through the preset envelope shapes, which define how the attributes (corresponding to the rows of the control grids) change with various aspects of where the particle is situated (corresponding to the columns).

## Description of files
### kudu6.pde
Contains the main animation loop and defines preset shapes.
### sceneGraph.pde
The class that defines the tree structure for paths and particles. Since particles and paths share the same superclass, the nesting of paths is extensible. The main program uses only 2 'layers' of path.
### spreadParticle.pde
The class that stores the shape data for both paths and particles. Defines how particles/paths transform relative to their associated attributes.
### attributes.pde
Class that manages the dependent attributes.
### bezier.pde
Implementation of a Bezier curve.
### envelope.pde
Defines
### envelopeMatrix.pde
### grid.pde
A clickable grid that .
### lambda.pde
Implementation of functions-as-objects, for use with the envelope class when creating a new envelope.
### mutableShape.pde
WIP: Planned functionality for creating shapes/paths whose attributes can be mutated randomly.

## Running the code
Kudu should be straightforward to run via the Processing IDE. It requires the Geomerative library (https://github.com/rikrd/geomerative) to be installed.