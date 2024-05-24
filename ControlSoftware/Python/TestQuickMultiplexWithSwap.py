from SonicSurface import SonicSurface
import time

dist = 0.18

array = SonicSurface()
array.connect( -1 )
   
array.focusAtPos(-0.04,dist,0) #first we focus 4cm to the left
time.sleep(1); #we wait 1 sec
array.focusAtPos(0.04,dist,0) #now we focus 4cm to the right
time.sleep(1); #we wait 1 sec

#the last 2 patterns are in the buffer of the FPGA 
#so we can quickly swap between them by only sending the commit command (1 byte)
for _ in range(2000):
    array.sendCommit();
    time.sleep(0.005);
    
for _ in range(2000):
    array.sendCommit();
    time.sleep(0.002);
    
for _ in range(2000):
    array.sendCommit();
    time.sleep(0.001);
    
array.switchOnOrOff( False )

array.disconnect()