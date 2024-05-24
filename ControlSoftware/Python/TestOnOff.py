from SonicSurface import SonicSurface
import time

array = SonicSurface()
array.connect( -1 ) 

for _ in range(3):
    array.switchOnOrOff( True )
    time.sleep(1)
    array.switchOnOrOff( False )
    time.sleep(1)
        
array.disconnect()