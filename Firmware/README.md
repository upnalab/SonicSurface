FPGA jic are the code to upload into the FPGA using the Blaster device (or any other compatible one) they are the precompiled verions of what is in the project folder. They have no phase calibration for the emitters so you should do one of the following:
1) solder the transducers with the right polarity
2) put the phase calibration on the simulation
3) recompile the project into a new jic with the calibration hardcoded

FPGAPrimary is enabled with the command 192 and generates its own clock on port D
FPGASecondary is enabled with the command 192 and syncs its clock with what is input in port A
FPGATactileModulation is a Primary board that modulates the emitted waves at 200Hz (or at a config speed). 

ESP contain optional controllers. The haptic controller is designed to be used with FPGATactileModulation