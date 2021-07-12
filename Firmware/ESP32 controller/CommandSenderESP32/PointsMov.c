/*
 * PointsMov.c
 *
 *  Created on: 21 jun. 2021
 *      Author: asier.marzo
 */


void points_reset(const int nPoints,  float points[], const float separation, const float height){
	points[0*3 + 0] = separation/2; points[1*3 + 0] = -separation/2;
	points[0*3 + 1] = points[1*3 + 1] = height;
	points[0*3 + 2] = points[1*3 + 2] = 0;
}


void clearVector(float v[3]){
	v[0] = v[1] = v[2] = 0;
}
void addVector(float a[3], float const b[3]){
	a[0] += b[0];
	a[1] += b[1];
	a[2] += b[2];
}
void divVector(float a[3], const float d){
	a[0] /= d;
	a[1] /= d;
	a[2] /= d;
}
void subVec(float const a[3], float const b[3], float target[3]){
	target[0] = a[0] - b[0];
	target[1] = a[1] - b[1];
	target[2] = a[2] - b[2];
}
void resizeVec(float a[3], const float len){
	const float currentLength = sqrt(a[0]*a[0] + a[1]*a[1] + a[2]*a[2]);
	if (currentLength > 0.0000001)
		divVector(a, currentLength/len);
}
void calcCenter(float center[3], const int nPoints, float const points[] ){
	clearVector( center );
	for(int i = 0; i < nPoints; i+=1){
		addVector(center, & points[i*3] );
	}
	divVector( center, nPoints );
}


void points_bringCloser(const int nPoints,  float points[],const float dist){
	float center[3];
	calcCenter( center, nPoints, points );
	float diff[3];
	for(int i = 0; i < nPoints; i+=1){
		float* cPoint = &points[i*3];
		subVec(center, cPoint, diff);
		resizeVec(diff, dist);
		addVector(cPoint, diff);
	}
}

void points_rotateAroundY(const int nPoints,  float points[],const float rad){
	float center[3];
	calcCenter( center, nPoints, points );
	const float cosA = cos(rad);
	const float sinA = sin(rad);

	for(int i = 0; i < nPoints; i+=1){
		float* cPoint = &points[i*3];
		cPoint[0] -= center[0];
		cPoint[2] -= center[2];
		const float newX = cosA * cPoint[0] - sinA * cPoint[2];
		const float newZ = sinA * cPoint[0] + cosA * cPoint[2];
		cPoint[0] = newX + center[0];
		cPoint[2] = newZ + center[2];
	}
}
