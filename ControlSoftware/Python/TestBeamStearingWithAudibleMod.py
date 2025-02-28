from SonicSurface import SonicSurface
import time
import numpy as np

#this code will run forever sweeping a focal point from -Angle to Angle
#press control+c to stop it
#it will add modulation (on,off) so that you can hear and feel the focal point

array = SonicSurface()
array.connect( -1 )
   
DIST = 5 #focus at 5 meters, it is almost equivalent to beam stearing
#put 0.12 to focus at 12cm and feel the focal point with your hand

ANGLE_MAX = 20 * (np.pi/180)
STEERING_SPEED = 0.5 * (np.pi/180) 

MOD_FREQ = 300
TIME_PER_POS = 0.1

WAIT_SWITCH = 1.0 / MOD_FREQ / 2
N_SWITCHES = int(TIME_PER_POS / WAIT_SWITCH)

def active_wait(seconds):
    start = time.perf_counter()  # Get the precise start time
    while time.perf_counter() - start < seconds:
        pass  # Busy-wait loop (uses CPU but is accurate)
        
direction = 1  # 1 for increasing, -1 for decreasing
angle = 0


try:
    while True:
        x = 0
        y = DIST * np.cos(angle)
        z = DIST * np.sin(angle)  
        
        array.focusAtPos(x,y,z)
        array.switchOnOrOff(False)
        
        for _ in range(N_SWITCHES): #swap quickly between the last two send phases (focus and off) that creates modulation
            array.sendCommit()
            #time.sleep(WAIT_SWITCH)
            active_wait(WAIT_SWITCH)
    
        #print("angle ", angle)
        angle += direction * STEERING_SPEED
        if angle >= ANGLE_MAX:
            direction = -1
        elif angle <= -ANGLE_MAX:
            direction = 1
            
except KeyboardInterrupt:
    array.disconnect()
    
    
