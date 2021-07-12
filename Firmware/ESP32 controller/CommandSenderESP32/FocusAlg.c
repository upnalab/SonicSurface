/*
 * FocusAlg.c
 *
 *  Created on: 24 may. 2021
 *      Author: asier.marzo
 *      Static stuff to calculate emission phases to focus at target points
 */

#include "FocusAlg.h"
#include "EmitterPos.h"
#include "Arduino.h"

#define PHASE_RES 32

#define SOUND_SPEED 346
#define FREQ 40000

float pointA[MAX_POINTS], pointB[MAX_POINTS]; //target field at each virtual point
float transA[N_EMITTERS], transB[N_EMITTERS]; //complex emission of each transducer
float tpA[N_EMITTERS][MAX_POINTS], tpB[N_EMITTERS][MAX_POINTS]; //propagator from transducer to point [T][P]

void ibp_iterate(const int nPoints){
	//project emitters into control points
	for (int j = 0; j < nPoints; ++j) {
		pointA[j] = pointB[j] = 0;
		for (int i = 0; i < N_EMITTERS; ++i) {
			pointA[j] += transA[i] * tpA[i][j] - transB[i] * tpB[i][j];
			pointB[j] += transA[i] * tpB[i][j] + transB[i] * tpA[i][j];
		}
	}

	//normalize control points
	for (int i = 0; i < nPoints; ++i) {
		const float dist = sqrtf(pointA[i]*pointA[i] + pointB[i]*pointB[i]);
		pointA[i] /= dist;
		pointB[i] /= dist;
	}

	//backproject control points into transducers (use the conjugate to backpropagate)
	for (int i = 0; i < N_EMITTERS; ++i) {
		transA[i] = transB[i] = 0;
		for (int j = 0; j < nPoints; ++j) {
			transA[i] += pointA[j] * tpA[i][j] - pointB[j] * -tpB[i][j];
			transB[i] += pointA[j] * -tpB[i][j] + pointB[j] * tpA[i][j];
		}
	}

	//normalize transducer amplitude
	for (int i = 0; i < N_EMITTERS; ++i) {
		const float dist = sqrtf(transA[i]*transA[i] + transB[i]*transB[i]);
		transA[i] /= dist;
		transB[i] /= dist;
	}
}

float vectorDist(const float vecA[], const float vecB[]){
	const float diffX = vecA[0] - vecB[0];
	const float diffY = vecA[1] - vecB[1];
	const float diffZ = vecA[2] - vecB[2];
	return sqrtf( diffX*diffX + diffY*diffY + diffZ*diffZ);
}

void calcFieldForEmitter(const float emitterPos[], const float pointPos[], const float phase, float* fieldA, float* fieldB) {

	const static float mSpeed = SOUND_SPEED;
	const float omega = 2 * PI * FREQ;
	const float k = omega / mSpeed;// wavenumber

	const float dist = vectorDist(emitterPos, pointPos);

	//const static float ap = 0.009;
	const float directivity = 1; //TODO add proper directivity model

	const float ampDirAtt = directivity / dist;
	const float kdPlusPhase = k * dist + phase;
	*fieldA = ampDirAtt * cos(kdPlusPhase);
	*fieldB = ampDirAtt * sin(kdPlusPhase);
}

void ibp_initPropagators(const int nPoints,  float const pointPos[]){
	//initialise target points
	for (int i = 0; i < nPoints; ++i) {
		pointA[i] = 1; //we just want amplitude 1, any phase does the job to initiate them
		pointB[i] = 0;

		//calculate the propagators from the transducers j into point i
		for (int j = 0; j < N_EMITTERS; ++j) {
			calcFieldForEmitter(& EMITTER_POS[j*3], & pointPos[i*3], 0, &tpA[j][i], &tpB[j][i] );
		}

	}
}

void ibp_initEmitters(){
	for (int j = 0; j < N_EMITTERS; ++j) {
		transA[j] = 1;
		transB[j] = 0;
	}
}

void ibp_applySolution(const int nPoints, byte phases[]) {
	for (int i = 0; i<N_EMITTERS; ++i) {
		float angle = atan2(transB[i], transA[i]);
		if (angle < 0)
			angle += 2*PI;
		byte phase = (char)(angle / (2*PI) * PHASE_RES);
     
		phases[i] = phase;
	}
}




void simpleFocusAt( float const pointPos[3], byte phases[] ){
	const float wavelength = SOUND_SPEED / (double) FREQ;
	for (int i = 0; i<N_EMITTERS; ++i) {
		const float dist = vectorDist(& EMITTER_POS[i*3] , pointPos);
		const float lambdas = dist / wavelength;
		const float targetPhase = 1.0 - (lambdas- (int)lambdas);
      
		phases[i] = (byte)(targetPhase * 32);
	}
}

void multiFocusAt(const int nPoints,  float const pointPos[],  byte phases[] ){
	const float wavelength = SOUND_SPEED / (double) FREQ;
	for (int i = 0; i<N_EMITTERS; ++i) {
		const int targetPoint = i % nPoints;

		const float dist = vectorDist(& EMITTER_POS[i*3] ,& pointPos[targetPoint*3]);
		const float lambdas = dist / wavelength;
		const float targetPhase = 1.0 - (lambdas- (int)lambdas);

		phases[i] = (byte)(targetPhase * 32);
	}
}
