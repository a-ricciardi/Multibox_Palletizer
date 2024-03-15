/* Automation Studio generated header file */
/* Do not edit ! */
/* GenericAx  */

#ifndef _GENERICAX_
#define _GENERICAX_
#ifdef __cplusplus
extern "C" 
{
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
/* Constants */
#ifdef _REPLACE_CONST
 #define IDLE 0U
 #define CHANGE_VELOCITY 1U
 #define CHANGE_POSITION 2U
 #define EMERGENCY_STOP_REQUEST 3U
#else
 _GLOBAL_CONST plcword IDLE;
 _GLOBAL_CONST plcword CHANGE_VELOCITY;
 _GLOBAL_CONST plcword CHANGE_POSITION;
 _GLOBAL_CONST plcword EMERGENCY_STOP_REQUEST;
#endif




/* Datatypes and datatypes of function blocks */
typedef enum GA_State
{	CheckCommand,
	WaitTargetPosition,
	WaitTargetVelocity,
	FaultState
} GA_State;

typedef struct GenericAxis
{
	/* VAR_INPUT (analog) */
	plcword Command;
	float ActualPosition;
	float ActualVelocity;
	float NewSetPoint;
	signed short DeviceTimer;
	/* VAR_OUTPUT (analog) */
	float TargetVelocity;
	float TargetPosition;
	/* VAR (analog) */
	enum GA_State AxisState;
	signed short Timer;
	/* VAR_INPUT (digital) */
	plcbit TGT_SENSOR;
	plcbit Reset;
	/* VAR_OUTPUT (digital) */
	plcbit InPosition;
	plcbit InVelocity;
	plcbit DeviceFault;
} GenericAxis_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void GenericAxis(struct GenericAxis* inst);


#ifdef __cplusplus
};
#endif
#endif /* _GENERICAX_ */

