/*
 * FocusAlg.h
 *
 *  Created on: 24 may. 2021
 *      Author: asier.marzo
 */

#ifdef __cplusplus
extern "C" {
#endif

#ifndef FOCUSALG_H_
#define FOCUSALG_H_

#include "Arduino.h"

#define MAX_POINTS 4

void ibp_initEmitters();
void ibp_initPropagators(const int nPoints,  float const pointPos[]);
void ibp_iterate(const int nPoints);
void ibp_applySolution(const int nPoints, byte phases[]);

void simpleFocusAt( float const pointPos[3],  byte phases[] );

void multiFocusAt(const int nPoints,  float const pointPos[],  byte phases[] );

#endif /* FOCUSALG_H_ */

#ifdef __cplusplus
}
#endif
