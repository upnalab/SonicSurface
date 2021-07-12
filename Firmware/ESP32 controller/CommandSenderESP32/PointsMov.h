/*
 * PointsMov.h
 *
 *  Created on: 21 jun. 2021
 *      Author: asier.marzo
 */

#ifdef __cplusplus
extern "C" {
#endif

#ifndef POINTSMOV_H_
#define POINTSMOV_H_

#define POINTS_MOV_SEP 0.10 //starting separation of the points
#define POINTS_MOV_ROT 0.004 //radians per step
#define POINTS_MOV_ATTRACTION 0.00003 //m per step


void points_reset(const int nPoints,  float points[], const float separation, const float height );
void points_bringCloser(const int nPoints,  float points[], const float dist);
void points_rotateAroundY(const int nPoints,  float points[], const float rad);


#endif /* POINTSMOV_H_ */

#ifdef __cplusplus
}
#endif
