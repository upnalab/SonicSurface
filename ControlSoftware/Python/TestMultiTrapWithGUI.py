from SonicSurface import SonicSurface
import cv2
import numpy as np

array = SonicSurface()
array.connect( -1 )

dist = 0.18
IMG_SIZE = 640

needsArrayUpdate = True
useIBP = False
img = np.zeros((IMG_SIZE, IMG_SIZE, 3), np.uint8)
winName = "Control Focal Points"
positions = [[-1,-1], [-1,-1], [-1,-1]]

COLORS = [[255, 0, 0], [0, 255, 0], [0, 0, 255]]

def onClickAddCircle(event, x, y, flags, param):
    global positions, needsArrayUpdate
    eventToIndex = {
        cv2.EVENT_LBUTTONDOWN: 0,
        cv2.EVENT_RBUTTONDOWN: 1,
        cv2.EVENT_MBUTTONDOWN: 2,
    }
    index = eventToIndex.get(event, -1)
    if index == -1:
        return
    
    positions[index][0] = x
    positions[index][1] = y
    needsArrayUpdate = True
    
def sendPoints(array, positions, distance, useIBP=True):
    global IMG_SIZE
    nPoints = 0
    for pos in positions:
        if pos[0] != -1:
            nPoints += 1
    points = np.zeros([nPoints, 3])
    index = 0
    for pos in positions:
        if pos[0] != -1:
            points[index,0] = ((pos[0] / IMG_SIZE) - 0.5) * 0.16 
            points[index,1] = distance
            points[index,2] = ((pos[1] / IMG_SIZE) - 0.5) * 0.16 
            index += 1
         
    if nPoints == 0:
        array.switchOnOrOff( False )
    elif nPoints == 1:
        array.focusAt(points[0])
    else:
        if useIBP:
            array.multiFocusIBP(points)
        else:
            array.multiFocusChecker(points)
            

cv2.namedWindow(winName)
cv2.setMouseCallback(winName, onClickAddCircle)

while True:
    img = 0 * img
    index = 1
    for pos in positions:
        cv2.circle(img, (pos[0], pos[1]), 20, COLORS[index % len(COLORS)], -1)
        cv2.putText(img, str(index), (pos[0] - 10, pos[1] + 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)
        index += 1
        
    cv2.imshow(winName, img)
    
    key = cv2.waitKey(1) & 0xFF
    if key == ord('0'): #clear
        positions = [[-1,-1], [-1,-1], [-1,-1]]
        needsArrayUpdate = True
    elif key == ord('1'): #IBP
        useIBP = True
        needsArrayUpdate = True
    elif key == ord('2'): #Checker
        useIBP = False
        needsArrayUpdate = True    

    if needsArrayUpdate:
        sendPoints(array, positions, dist, useIBP)
        needsArrayUpdate = False    

    if key == ord('q') or key == 27:
        break
    
array.disconnect();
cv2.destroyAllWindows()
