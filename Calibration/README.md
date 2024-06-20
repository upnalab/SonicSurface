# Calibration
Calibration involves two components. Setting transducer phase offsets as described in the 
[Instructable](https://www.instructables.com/SonicSurface-Phased-array-for-Levitation-Mid-air-T/) (Step 6) and configuring transducer 
positions. The default positions will work for a single array but transducer positions for opposing arrays depends on the array orientations.

Transducer locations in x,y,z for the Java code are specified in [Simulations/twoOpposedArrays.xml.gz](../Simulations/twoOpposedArrays.xml.gz) and for the ESP32 version in 
[EmitterPos.c](../Firmware/ESP32%20controller/CommandSenderESP32/EmitterPos.c).

## Transducer Locations
Transducer locations are chosen for circuit board layout convenience and are positioned in the array as follows.
![Transducer positions](transducerpositions.png)
These transducer locations must be specified in x,y,z coordinates. The opposing array can be in one of four possible rotations and each of the transducers will be in a different x,z location depending on the rotation chosen.

The data required for [EmitterPos.c](../Firmware/ESP32%20controller/CommandSenderESP32/EmitterPos.c) can be generated with the [CalculateEmitterPosData](CalculateEmitterPosData.xslx) (Microsoft Excel) spreadsheet.  

In the spreadsheet, interpret "Top Board Transducer Positions" as looking up at the top board and "Bottom Board Transducer Positions" as looking up from underneath the bottom array. The bottom board positions are derived from the top board. Reversing the direction of the numbers in column "U" will reverse the transducers vertically and changing the "INDIRECT" function to use row 4 rather than row 3 will reverse the transducers horizontally. By choosing the correct combination, data for each of the four possible orientations for the bottom board can be generated. Once the transducers are correctly positioned the data, highlighted in green, can be cut and pasted into [EmitterPos.c](../Firmware/ESP32%20controller/CommandSenderESP32/EmitterPos.c).

The spreadsheet is currently configured for the primary array at the top and the bottom secondary array to be facing in the opposite direction as the top array, which is convenient for wiring. This data is used for the default [EmitterPos.c](../Firmware/ESP32%20controller/CommandSenderESP32/EmitterPos.c).

