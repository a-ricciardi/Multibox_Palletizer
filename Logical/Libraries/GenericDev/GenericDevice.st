
FUNCTION_BLOCK GenericDevice
	
	(* CLOCK HANDLER *)
	IF (DeviceClock AND (DeviceTimer > 0))THEN
		DeviceTimer := DeviceTimer - 1;
	END_IF;


	(* DEVICE SENSORS HANDLER *)
	CASE (DeviceType AND DEVICE_FEEDBACK_MASK) OF
			
		DEVICE_WITH_ENABLE_FEEDBACK:
			
			DeviceDisabledSensor := NOT DeviceEnabledSensor AND	
			((DeviceState = DeviceDisabledState) OR (DeviceState = DeviceDisablePhaseState AND DeviceTimeout));
			
			DeviceDisabled 		 := NOT DeviceEnabled AND
			((DeviceState = DeviceDisabledState) OR (DeviceState = DeviceDisablePhaseState AND DeviceTimeout));
		
			
		DEVICE_WITH_DISABLE_FEEDBACK :
			
			DeviceEnabled 		:= NOT DeviceDisabled AND 
			((DeviceState = DeviceEnabledState) OR (DeviceState = DeviceEnablePhaseState AND DeviceTimeout));
			
			DeviceEnabledSensor := NOT DeviceDisabledSensor AND	
			((DeviceState = DeviceEnabledState) OR (DeviceState = DeviceEnablePhaseState AND DeviceTimeout));
				
			
		DEVICE_WITHOUT_FEEDBACK:
			
			DeviceEnabled  		 := (DeviceState = DeviceEnabledState) OR (DeviceState = DeviceEnablePhaseState AND DeviceTimeout);
			
			DeviceDisabled 		 := (DeviceState = DeviceDisabledState) OR (DeviceState = DeviceDisablePhaseState AND DeviceTimeout);
			
			DeviceEnabledSensor  := (DeviceState = DeviceEnabledState) OR ((DeviceState = DeviceEnablePhaseState) AND DeviceTimeout);
			
			DeviceDisabledSensor := (DeviceState = DeviceDisabledState) OR ((DeviceState = DeviceDisablePhaseState) AND DeviceTimeout);
		
	END_CASE;
	
	
	(* INITIALIZATION HANDLER *)
	IF (DeviceOperation = INIT) THEN

		CASE (DeviceType AND DEVICE_FEEDBACK_MASK) OF
			
			DEVICE_WITH_ENABLE_FEEDBACK:
				
				DeviceDisabled := NOT DeviceEnabled;
				
				
			DEVICE_WITH_DISABLE_FEEDBACK:
				
				DeviceEnabled := NOT DeviceDisabled;
				
				
			DEVICE_WITHOUT_FEEDBACK:
				
				DeviceEnabled  := DeviceEnablePreset;
				DeviceDisabled := NOT DeviceEnabled;
			
		END_CASE;
		
		DeviceEnableRequest  := FALSE;
		DeviceDisableRequest := FALSE;
		
		IF (DeviceEnablePreset) THEN
			EnableDevice := TRUE;
			DeviceTimer  := DeviceEnableTime;
			
			IF (NOT (DeviceDisabled AND DeviceEnabled)) THEN
				DeviceState := DeviceEnablePhaseState;
			ELSE
				DeviceState := DeviceEnabledState;
			END_IF;
			
			DeviceNotInitialized := NOT DeviceEnabled OR DeviceDisabled;
			
		ELSE
			EnableDevice := FALSE;
			DeviceTimer := DeviceDisableTime;
			
			IF (NOT (DeviceDisabled AND DeviceEnabled)) THEN
				DeviceState := DeviceDisablePhaseState;
			ELSE
				DeviceState := DeviceDisabledState;
			END_IF;
			
			DeviceNotInitialized := (DeviceEnabled OR NOT DeviceDisabled);
		END_IF;
		
	END_IF;

	
	(* DEVICE CONTROL HANDLER *)
	CASE (DeviceState) OF
		
		DeviceDisabledState:
			
			DeviceDisableRequest := FALSE;
			IF (DeviceEnableRequest) THEN
				EnableDevice := TRUE;
				DeviceTimer  := DeviceEnableTime;
				DeviceState  := DeviceEnablePhaseState;
			END_IF;
			
			
		DeviceEnablePhaseState:
			
			IF DeviceDisableRequest THEN
				DeviceEnableRequest	:= FALSE;
				EnableDevice	    := FALSE;
				DeviceTimer	        := DeviceDisableTime;
				DeviceState	        := DeviceDisablePhaseState;
			END_IF;
			
			IF DeviceEnabledSensor THEN
				DeviceEnableRequest := FALSE;
				DeviceTimer	        := 0;
				DeviceState         := DeviceEnabledState;
			END_IF;
		
			
		DeviceEnabledState:
			
			DeviceEnableRequest	:= FALSE;
			IF DeviceDisableRequest THEN
				EnableDevice := FALSE;
				DeviceTimer	 := DeviceDisableTime;
				DeviceState  := DeviceDisablePhaseState;
			END_IF;
			
			
		DeviceDisablePhaseState:
			
			IF DeviceEnableRequest THEN
				DeviceDisableRequest := FALSE;
				EnableDevice		 := TRUE;
				DeviceTimer			 := DeviceEnableTime;
				DeviceState			 := DeviceEnablePhaseState;
			END_IF;
			
			IF DeviceDisabledSensor THEN
				DeviceDisableRequest := FALSE;
				DeviceTimer          := 0;
				DeviceState 		 := DeviceDisabledState;
			END_IF;
		
	END_CASE;
	
	(* DEVICE DIAGNOSIS HANDLER *)
	DeviceTimeout 			  := (DeviceTimer = 0);
	
	DeviceDisabledSensorFault := ((NOT EnableDevice AND NOT DeviceDisabledSensor AND NOT DeviceEnabledSensor) OR 
	(EnableDevice AND DeviceDisabledSensor AND DeviceEnabledSensor)) AND DeviceTimeout;
	
	DeviceEnabledSensorFault  := ((NOT EnableDevice AND DeviceDisabledSensor AND DeviceEnabledSensor) OR 
	(EnableDevice AND NOT DeviceDisabledSensor AND NOT DeviceEnabledSensor)) AND DeviceTimeout;
	
	DeviceActuatorFault 	  := ((NOT EnableDevice AND NOT DeviceDisabledSensor AND DeviceEnabledSensor) OR
	(EnableDevice AND DeviceDisabledSensor AND NOT DeviceEnabledSensor)) AND DeviceTimeout;
	
	DeviceFault 			  := DeviceDisabledSensorFault OR DeviceEnabledSensorFault OR DeviceActuatorFault;
	
	
	(* DEVICE ACTUATORS HANDLER *)
	CASE (DeviceType AND DEVICE_ACTUATION_MASK) OF
		
		DEVICE_WITH_DOUBLE_ACTUATION:
			
			DisableDevice := NOT EnableDevice;

			
		DEVICE_WITH_DA_NO_RETAIN:
			
			EnableDevice  := EnableDevice AND (DeviceState = DeviceEnablePhaseState);
			DisableDevice := NOT EnableDevice AND (DeviceState = DeviceDisablePhaseState);
		
	END_CASE;
	
	
END_FUNCTION_BLOCK