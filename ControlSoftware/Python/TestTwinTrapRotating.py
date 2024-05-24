from SonicSurface import SonicSurface
import time
import numpy as np

dist = 0.15

array = SonicSurface()
array.connect( -1 )

for angle in np.linspace(0, np.pi * 2, 100):
    array.vortexAt(0,dist,0, 1, True, angle)
    time.sleep(0.1)

array.switchOnOrOff( False )
array.disconnect()