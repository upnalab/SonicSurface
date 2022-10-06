# ESP32 Software
The Sonic surface can be controlled from a Java application or an ESP32 microcontroller. This directory contains the ESP32 levitation code.

## ESP32 Commands

All commands must have a trailing space and are case sensitive.

- on

Switch all transducers on.
- off

Switch all transducers off.
- top

Switch all transducers in top array on.

- bottom

Switch all transducers in bottom array on.

- focus= x y z 

Set the focus point. Positions are in metres and seperated by a space. 0, half array height, 0 will be at the centre of the array.

- focusMulti= x y z x y z ...

Set multiple focus points. Positions are in metres and seperated by a space. Up to 4 points can be specified and the trapping force is lower than for single focus points.

- itersIBP= 

Set IBP iterations. 

- focusIBP= x y z x y z x y z x y z 

Multipoint with IBP iterations. Slower than focusMulti.

- phases=

Send whatever phases are currently defined to the SonicSurface.
 
- switch

Switch the phases between the top and bottom array.

- version 

Display version.
