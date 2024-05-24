from SonicSurface import SonicSurface
import time

dist = 0.18

array = SonicSurface()
array.connect( -1 )

for _ in range(3):
    array.vortexAt(0,dist,0, 1)
    time.sleep(1)
    array.vortexAt(0,dist,0, -1)
    time.sleep(1)


array.switchOnOrOff( False )
array.disconnect()