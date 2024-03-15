
{REDUND_ERROR} {REDUND_UNREPLICABLE} FUNCTION_BLOCK GenericDevice (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		DeviceOperation : {REDUND_UNREPLICABLE} INT;
		DeviceType : {REDUND_UNREPLICABLE} INT;
		DeviceEnabledSensor : {REDUND_UNREPLICABLE} BOOL;
		DeviceDisabledSensor : {REDUND_UNREPLICABLE} BOOL;
		DeviceClock : {REDUND_UNREPLICABLE} BOOL;
		DeviceEnableTime : {REDUND_UNREPLICABLE} INT;
		DeviceDisableTime : {REDUND_UNREPLICABLE} INT;
		DeviceDiagnosticsEnabled : {REDUND_UNREPLICABLE} BOOL;
		DeviceEnablePreset : {REDUND_UNREPLICABLE} BOOL;
		DeviceEnabled : {REDUND_UNREPLICABLE} BOOL;
		DeviceDisabled : {REDUND_UNREPLICABLE} BOOL;
	END_VAR
	VAR_OUTPUT
		EnableDevice : {REDUND_UNREPLICABLE} BOOL;
		DisableDevice : {REDUND_UNREPLICABLE} BOOL;
		DeviceEnabledSensorFault : {REDUND_UNREPLICABLE} BOOL;
		DeviceDisabledSensorFault : {REDUND_UNREPLICABLE} BOOL;
		DeviceActuatorFault : {REDUND_UNREPLICABLE} BOOL;
		DeviceFault : {REDUND_UNREPLICABLE} BOOL;
		DeviceNotInitialized : {REDUND_UNREPLICABLE} BOOL;
	END_VAR
	VAR_IN_OUT
		DeviceEnableRequest : BOOL;
		DeviceDisableRequest : BOOL;
	END_VAR
	VAR
		DeviceState : {REDUND_UNREPLICABLE} DeviceStateType;
		DeviceTimer : {REDUND_UNREPLICABLE} INT;
		DeviceTimeout : {REDUND_UNREPLICABLE} BOOL;
	END_VAR
	VAR CONSTANT
		INIT : INT := 0;
		RUN : INT := 1;
	END_VAR
END_FUNCTION_BLOCK
