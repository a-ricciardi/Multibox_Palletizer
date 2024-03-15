
FUNCTION_BLOCK GenericAxis
	VAR_INPUT
		Command : WORD := 95;
		ActualPosition : REAL;
		ActualVelocity : REAL;
		NewSetPoint : REAL;
		DeviceTimer : INT;
		TGT_SENSOR : BOOL;
	END_VAR
	VAR_OUTPUT
		TargetVelocity : REAL;
		TargetPosition : REAL;
		InPosition : BOOL;
		InVelocity : BOOL;
		DeviceFault : BOOL;
	END_VAR
	VAR
		AxisState : GA_State := CheckCommand;
		Timer : INT;
	END_VAR
	VAR_INPUT
		Reset : BOOL;
	END_VAR
END_FUNCTION_BLOCK
