from SonicSurface import SonicSurface
import time
import numpy as np


array = SonicSurface()
array.connect( -1 )
   
dist = 0.18
array.focusAtPos(0,dist,0)
_ = input("Place particle at center, press to continue...")


rad = 0.04
for x in np.linspace(0.0,rad, 50):
    array.focusAtPos(x,dist,0)
    time.sleep(0.01)
    
for angle in np.linspace(0,2 *2*np.pi, 250):
    array.focusAtPos(np.cos(angle) * rad, dist, np.sin(angle) * rad)
    time.sleep(0.01)



array.disconnect()