from SonicSurface import SonicSurface
import time
import numpy as np
import keyboard

dist = 0.18

array = SonicSurface()
array.connect( -1 , 1462857)
#for standard SonicSurface
#for div7 use baudrate 1462857
#for div4 (not working) 2000000 2048000 2560000

xPos = 0   
array.focusAtPos(xPos,dist,0)
print("q,a amplitude.  w,s stepSize.  e,d  delay")
_ = input("Place particle at center, press to continue...")

direction = -1
amplitude = 0.06 
stepSize = 0.001            
waitTime = 0.01

while True:
    xPos += direction * stepSize
    if xPos > amplitude/2:
        direction = -1
    elif xPos < -amplitude/2:
        direction = 1       
    array.focusAtPos(xPos,dist,0)
    
    if keyboard.is_pressed('q'):
        amplitude += 0.001
    elif keyboard.is_pressed('a'):
        amplitude -= 0.001
        
    if keyboard.is_pressed('w'):
        stepSize += 0.00005
    elif keyboard.is_pressed('s'):
        stepSize -= 0.00005
        
    if keyboard.is_pressed('e'):
        waitTime += 0.001
    elif keyboard.is_pressed('d'):
        waitTime -= 0.001
        if waitTime < 0:
            waitTime = 0
    
    if keyboard.is_pressed('esc'):
        print("Exiting...")
        break
        
    time.sleep( waitTime )

print("amplitude ", amplitude, " stepSize ", stepSize, " wait ", waitTime)
array.switchOnOrOff( False )
array.disconnect()