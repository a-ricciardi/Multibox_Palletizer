/* Automation Studio generated header file */
/* Do not edit ! */
/* SignalMng  */

#ifndef _SIGNALMNG_
#define _SIGNALMNG_
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
 #define INIT 0
 #define RUN 1
 #define START_CONFIGURATION 2
 #define CONFIGURATION 3
 #define START_GENERATION 4
 #define GENERATION 5
 #define ALARM 1
 #define ANOMALY 2
 #define WARNING 3
 #define INFORMATION 4
 #define AUX_RESET 512
 #define UNCONDITIONED_RESET 16384
 #define AUTO_CONDITIONED_RESET 8192
 #define AUTO_PROVISIONAL_RESET 4096
 #define AUTO_PRIORITY_RESET 2048
 #define AUTO_RESET 1024
 #define SIGNAL_TYPE_MASK 7
 #define NONE 0U
 #define EMERGENCY_STOP 1U
 #define IMMEDIATE_STOP 2U
 #define ON_PHASE_STOP 4U
 #define MACHINE_OUT_OF_PHASE 256U
 #define MACHINE_INHIBITION 512U
 #define MATERIALS_RUN_OUT_LAMP 1024U
 #define MATERIALS_RUN_OUT_BUZZER 2048U
 #define IO_DIAGNOSTIC_INHIBITION 32768U
#else
 _GLOBAL_CONST signed short INIT;
 _GLOBAL_CONST signed short RUN;
 _GLOBAL_CONST signed short START_CONFIGURATION;
 _GLOBAL_CONST signed short CONFIGURATION;
 _GLOBAL_CONST signed short START_GENERATION;
 _GLOBAL_CONST signed short GENERATION;
 _GLOBAL_CONST signed long ALARM;
 _GLOBAL_CONST signed long ANOMALY;
 _GLOBAL_CONST signed long WARNING;
 _GLOBAL_CONST signed long INFORMATION;
 _GLOBAL_CONST signed long AUX_RESET;
 _GLOBAL_CONST signed long UNCONDITIONED_RESET;
 _GLOBAL_CONST signed long AUTO_CONDITIONED_RESET;
 _GLOBAL_CONST signed long AUTO_PROVISIONAL_RESET;
 _GLOBAL_CONST signed long AUTO_PRIORITY_RESET;
 _GLOBAL_CONST signed long AUTO_RESET;
 _GLOBAL_CONST signed long SIGNAL_TYPE_MASK;
 _GLOBAL_CONST plcdword NONE;
 _GLOBAL_CONST plcdword EMERGENCY_STOP;
 _GLOBAL_CONST plcdword IMMEDIATE_STOP;
 _GLOBAL_CONST plcdword ON_PHASE_STOP;
 _GLOBAL_CONST plcdword MACHINE_OUT_OF_PHASE;
 _GLOBAL_CONST plcdword MACHINE_INHIBITION;
 _GLOBAL_CONST plcdword MATERIALS_RUN_OUT_LAMP;
 _GLOBAL_CONST plcdword MATERIALS_RUN_OUT_BUZZER;
 _GLOBAL_CONST plcdword IO_DIAGNOSTIC_INHIBITION;
#endif




/* Datatypes and datatypes of function blocks */
#ifdef _BUR_USE_DECLARATION_IN_IEC
typedef struct SignalManager
{
	/* VAR_INPUT (analog) */
	signed short OperationType;
	signed long SignalType;
	signed short SignalCode;
	plcdword SignalOutput;
	/* VAR_OUTPUT (analog) */
	plcdword SignalOutputs;
	plcword SignalPriorityCode;
	signed short NumberOfAlarms;
	signed short NumberOfAnomalies;
	signed short NumberOfWarnings;
	signed short NumberOfInformation;
	signed short ActiveSignalCodes[20];
	signed short NumberOfActiveAlarms;
	signed short NumberOfActiveAnomalies;
	signed short NumberOfActiveWarning;
	signed short NumberOfActiveInformation;
	signed short FirstSignalIndex;
	signed short FirstActiveSignalIndex;
	signed short SecondActiveSignalIndex;
	signed short ThirdActiveSignalIndex;
	signed short FourthActiveSignalIndex;
	signed short FifthActiveSignalIndex;
	/* VAR (analog) */
	signed short LastSignalIndex;
	signed short LastActiveSignalIndex;
	signed short Index;
	signed short BaseIndex;
	signed short i;
	signed short LastInformationIndex;
	signed short LastAnomalyIndex;
	signed short LastWarningIndex;
	plcstring Firstslot[80];
	plcstring Secondslot[80];
	plcstring Thirdslot[80];
	plcstring Fourthslot[80];
	plcstring Fifthslot[81];
	/* VAR_INPUT (digital) */
	plcbit ActivationSignal;
	plcbit AutoResetSignal;
	plcbit Reset;
	plcbit KeyReset;
	/* VAR_OUTPUT (digital) */
	plcbit ResetEnable;
	plcbit AuxResetEnable;
	plcbit SignalTypeAlarm;
	plcbit SignalTypeAnomaly;
	plcbit SignalTypeWarning;
	plcbit SignalTypeInformation;
	plcbit SignalManagementError;
	/* VAR (digital) */
	plcbit ResetSignalsEnable;
	plcbit AuxResetActivation;
	plcbit ResetActivation;
	plcbit SignalRequest;
	plcbit SignalAckRequest;
	plcbit Signals[23];
	plcbit ActiveSignalRequest;
	plcbit ActiveSignalRequestAck;
	plcbit ResetOld;
	plcbit KeyResetOld;
	plcbit Condition;
	plcbit AuxResetRequired;
} SignalManager_typ;
#else
/* Data type SignalManager not declared. Data types with array elements whose starting indexes are not equal to zero cannot be used in ANSI C programs / libraries.*/
#endif



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void SignalManager(struct SignalManager* inst);


#ifdef __cplusplus
};
#endif
#endif /* _SIGNALMNG_ */

