# kudu
Generates animated particle systems

## Structure
Kudu generates particle systems whose attributes are defined by the 'envelopes' in the control panels on the left and right. The basic geometry of each system consists of 2 layers of paths:

![Structure](/structure.png)

## Interaction
Left-clicking and right-clicking on each individual cell will scroll through the preset envelope shapes, which define how the attributes (corresponding to the rows of the control grids) change with 

## Description of files
### kudu7.pde
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