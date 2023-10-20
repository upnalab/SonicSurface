#Static methods for generating grids of positions, emitter positions, normals and propagators
import numpy as np


class Waves:
    def planeGridZ(x,y,z, sizeX, sizeY, px,py):
        lX = np.linspace(x - sizeX/2, x + sizeX/2, px)
        lY = np.linspace(y - sizeY/2, y + sizeY/2, py)
        lZ = np.linspace(z,z, 1)
        [mX, mY, mZ] = np.meshgrid(lX, lY, lZ)
        nPoints = px * py
        grid = np.zeros([nPoints,3])
        grid[:,0] = np.reshape( mX, (nPoints))
        grid[:,1] = np.reshape( mY, (nPoints))
        grid[:,2] = np.reshape( mZ, (nPoints))
        return grid
    
    def planeGridZEmitters(x,y,z, sizeX, sizeY, px,py):
        lXEmitters = np.linspace(x - sizeX/2, x + sizeX/2, px+2)[1:-1]
        lYEmitters = np.linspace(y - sizeY/2, y + sizeY/2, py+2)[1:-1]
        lZ = np.linspace(z,z, 1)
        [mX, mY, mZ] = np.meshgrid(lXEmitters, lYEmitters, lZ)
        nPoints = px * py
        grid = np.zeros([nPoints,3])
        grid[:,0] = np.reshape( mX, (nPoints))
        grid[:,1] = np.reshape( mY, (nPoints))
        grid[:,2] = np.reshape( mZ, (nPoints))
        return grid
    
    def planeGrid(x,y,z, v1, v2, px,py):
        l1 = np.linspace(-0.5, 0.5, px)
        l2 = np.linspace(-0.5, 0.5, py)
        [m1, m2] = np.meshgrid(l1, l2)
        nPoints = px*py
        fm1 = np.reshape(m1, [nPoints])
        fm2 = np.reshape(m2, [nPoints])
        grid = np.zeros([nPoints,3])
        grid[:,0] = v1[0] * fm1 + v2[0] * fm2 + x
        grid[:,1] = v1[1] * fm1 + v2[1] * fm2 + y
        grid[:,2] = v1[2] * fm1 + v2[2] * fm2 + z
        return grid
    
    def circleGrid(x,y,z, radious, nPoints):
        angles = np.linspace(-np.pi, np.pi, nPoints)
        grid = np.zeros([nPoints,3])
        grid[:,0] = np.cos(angles) * radious + x
        grid[:,1] = np.sin(angles) * radious + y
        grid[:,2] = z
        return grid
    
    def constNormals(positions, normal):
        s = positions.shape
        assert(s[1] == 3)
        normals = np.zeros([ s[0] ,3])
        normals[:,0] = normal[0]
        normals[:,1] = normal[1]
        normals[:,2] = normal[2]
        return normals
    
    def pointToNormals(positions, point):
        s = positions.shape
        assert(s[1] == 3)
        diff = point- positions
        nn = np.sqrt(diff[:, 0]*diff[:, 0] + diff[:, 1]*diff[:, 1] + diff[:, 2]*diff[:, 2])
        normals = np.zeros([ s[0] ,3])
        normals[:,0] = diff[:,0] / nn
        normals[:,1] = diff[:,1] / nn
        normals[:,2] = diff[:,2] / nn
        return normals
    
    def propPointToPoints(paPos, pbPositions, k):
        diff = pbPositions - paPos
        nd = np.sqrt(diff[:, 0]*diff[:, 0] + diff[:, 1]*diff[:, 1] + diff[:, 2]*diff[:, 2])
        prop =  1 / nd * np.exp(1j * k * nd )
        return prop


    def propPistonToPoints(ePos, eNormal, eApperture, pPositons, k):
        diff = pPositons - ePos
        nd = np.sqrt(diff[:, 0]*diff[:, 0] + diff[:, 1]*diff[:, 1] + diff[:, 2]*diff[:, 2]) 
        nn = np.sqrt(eNormal[0]*eNormal[0] + eNormal[1]*eNormal[1] + eNormal[2]*eNormal[2])
        angle = np.arccos((diff[:, 0]*eNormal[0] + diff[:, 1]*eNormal[1] + diff[:, 2]*eNormal[2])  /  nd / nn)
        dum = 0.5 * eApperture * k * np.sin(angle)
        dire =  np.sinc(dum) # sinc takes into acount the 0 / 0 error
                            # Check vessel function instead
        prop =  dire / nd * np.exp(1j * k * nd )
        return prop
    

    def calcPropagatorsPointsToPoints(positionsA, positionsB, k):
        shapeA = positionsA.shape
        shapeB = positionsB.shape
        assert(shapeA[1] == 3 and shapeB[1] == 3)
        props = np.zeros((shapeA[0], shapeB[0]), dtype = complex)
        for i in range(shapeA[0]):
            props[i,:] = Waves.propPointToPoints(positionsA[i,:],positionsB,k)
        return props
    
    def calcPropagatorsPistonsToPoints(ePositions, eNormals, pPositions, k, apperture):
        shapeA = ePositions.shape
        shapeB = pPositions.shape
        shapeN = eNormals.shape
        assert(shapeA[1] == 3 and shapeB[1] == 3 and shapeN[1] == 3)
        assert(shapeA[0] == shapeN[0])
        props = np.zeros((shapeA[0], shapeB[0]), dtype = complex)
        for i in range(shapeA[0]):
            props[i,:] = Waves.propPistonToPoints(ePositions[i,:],eNormals[i,:], apperture, pPositions,k)
        return props
        
    def phasesForFocusAt(positions, focalPoint, k):
        diff = positions - focalPoint
        distances = np.sqrt(diff[:, 0]*diff[:, 0] + diff[:, 1]*diff[:, 1] + diff[:, 2]*diff[:, 2])
        phases =   ( distances * k )%(2.0*np.pi)
        return phases