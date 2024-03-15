/* Automation Studio generated header file */
/* Do not edit ! */

#ifndef _BUR_1687707080_5_
#define _BUR_1687707080_5_

#include <bur/plctypes.h>

/* Constants */
#ifdef _REPLACE_CONST
#else
#endif


/* Variables */
_GLOBAL plcbit ComTCP_SimActive;
_GLOBAL plctime ComTCP_SimSendCycleTime;
_GLOBAL unsigned short ComTCP_SimServerPort;
_GLOBAL plcstring ComTCP_SimServerAddress[16];
_GLOBAL struct ComTCP_OUTPUTS_32BIT ComTCP_SimOutputs;
_GLOBAL struct ComTCP_INPUTS_32BIT ComTCP_SimInputs;





__asm__(".section \".plc\"");

/* Used IEC files */
__asm__(".ascii \"iecfile \\\"Logical/MNG_Package.var\\\" scope \\\"global\\\"\\n\"");

/* Exported library functions and function blocks */

__asm__(".previous");


#endif /* _BUR_1687707080_5_ */

