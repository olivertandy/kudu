# kudu
Generates animated particle systems

## Structure
Kudu generates particle systems whose attributes are defined by the 'envelopes' in the control panels on the left and right. The basic geometry of each system consists of 2 layers of paths:

## Interaction
Left-clicking and right-clicking on each individual cell will scroll through the preset envelope shapes, which define how the attributes (corresponding to the rows of the control grids) change with 

## Description of files
### kudu7
Contains the main animation loop and defines preset shapes.
### attributes
Class that manages the dependent attributes.


## Running the code
Kudu was created using the Processing command-line tool but should be straightforward to run via the Processing IDE. It requires the Geomerative library (https://github.com/rikrd/geomerative) to be installed.