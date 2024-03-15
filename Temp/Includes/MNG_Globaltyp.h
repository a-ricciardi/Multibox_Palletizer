/* Automation Studio generated header file */
/* Do not edit ! */

#ifndef _BUR_1687707080_3_
#define _BUR_1687707080_3_

#include <bur/plctypes.h>

/* Datatypes and datatypes of function blocks */
typedef struct VEC3
{	float x;
	float y;
	float z;
} VEC3;

typedef struct POSE6
{	float x;
	float y;
	float z;
	float a;
	float b;
	float c;
} POSE6;

typedef struct TRAFO
{	struct VEC3 baseX;
	float fill0;
	struct VEC3 baseY;
	float fill1;
	struct VEC3 baseZ;
	float fill2;
	struct VEC3 origin;
	float fill3;
} TRAFO;






__asm__(".section \".plc\"");

/* Used IEC files */
__asm__(".ascii \"iecfile \\\"Logical/MNG_Global.typ\\\" scope \\\"global\\\"\\n\"");

/* Exported library functions and function blocks */

__asm__(".previous");


#endif /* _BUR_1687707080_3_ */

