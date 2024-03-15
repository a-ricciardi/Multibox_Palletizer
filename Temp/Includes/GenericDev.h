/* Automation Studio generated header file */
/* Do not edit ! */
/* GenericDev  */

#ifndef _GENERICDEV_
#define _GENERICDEV_
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
 #define DEVICE_WITHOUT_FEEDBACK 64
 #define DEVICE_WITH_ENABLE_FEEDBACK 16
 #define DEVICE_WITH_DISABLE_FEEDBACK 32
 #define DEVICE_WITH_DOUBLE_FEEDBACK 48
 #define DEVICE_WITH_SINGLE_ACTUATION 1
 #define DEVICE_WITH_DOUBLE_ACTUATION 3
 #define DEVICE_WITH_DA_NO_RETAIN 2
 #define DEVICE_FEEDBACK_MASK 240
 #define DEVICE_ACTUATION_MASK 15
#else
 _GLOBAL_CONST signed short DEVICE_WITHOUT_FEEDBACK;
 _GLOBAL_CONST signed short DEVICE_WITH_ENABLE_FEEDBACK;
 _GLOBAL_CONST signed short DEVICE_WITH_DISABLE_FEEDBACK;
 _GLOBAL_CONST signed short DEVICE_WITH_DOUBLE_FEEDBACK;
 _GLOBAL_CONST signed short DEVICE_WITH_SINGLE_ACTUATION;
 _GLOBAL_CONST signed short DEVICE_WITH_DOUBLE_ACTUATION;
 _GLOBAL_CONST signed short DEVICE_WITH_DA_NO_RETAIN;
 _GLOBAL_CONST signed short DEVICE_FEEDBACK_MASK;
 _GLOBAL_CONST signed short DEVICE_ACTUATION_MASK;
#endif




/* Datatypes and datatypes of function blocks */
typedef enum DeviceStateType
{	DeviceDisabledState,
	DeviceEnablePhaseState,
	DeviceEnabledState,
	DeviceDisablePhaseState
} DeviceStateType;

typedef struct GenericDevice
{
	/* VAR_INPUT (analog) */
	signed short DeviceOperation;
	signed short DeviceType;
	signed short DeviceEnableTime;
	signed short DeviceDisableTime;
	/* VAR_IN_OUT (analog and digital) */
	plcbit* DeviceEnableRequest;
	plcbit* DeviceDisableRequest;
	/* VAR (analog) */
	enum DeviceStateType DeviceState;
	signed short DeviceTimer;
	signed short INIT;
	signed short RUN;
	/* VAR_INPUT (digital) */
	plcbit DeviceEnabledSensor;
	plcbit DeviceDisabledSensor;
	plcbit DeviceClock;
	plcbit DeviceDiagnosticsEnabled;
	plcbit DeviceEnablePreset;
	plcbit DeviceEnabled;
	plcbit DeviceDisabled;
	/* VAR_OUTPUT (digital) */
	plcbit EnableDevice;
	plcbit DisableDevice;
	plcbit DeviceEnabledSensorFault;
	plcbit DeviceDisabledSensorFault;
	plcbit DeviceActuatorFault;
	plcbit DeviceFault;
	plcbit DeviceNotInitialized;
	/* VAR (digital) */
	plcbit DeviceTimeout;
} GenericDevice_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void GenericDevice(struct GenericDevice* inst);


#ifdef __cplusplus
};
#endif
#endif /* _GENERICDEV_ */

