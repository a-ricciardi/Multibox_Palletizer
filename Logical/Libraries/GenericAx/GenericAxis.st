
(* TODO: Add your comment here *)
FUNCTION_BLOCK GenericAxis
	
	CASE (AxisState) OF
		
		CheckCommand:

			IF Command = IDLE THEN
				InPosition	:= FALSE;
				InVelocity	:= FALSE;
				Timer		:= DeviceTimer;
				DeviceFault	:= FALSE;
			END_IF;
			
			IF Command = CHANGE_POSITION THEN
				TargetPosition	:= NewSetPoint;
				AxisState		:= WaitTargetPosition;
			END_IF;
			
			IF Command = CHANGE_VELOCITY THEN
				TargetVelocity := NewSetPoint;
				AxisState	   := WaitTargetVelocity;
			END_IF;
			
			IF Command = EMERGENCY_STOP_REQUEST THEN
				TargetPosition	:= ActualPosition;
				TargetVelocity	:= 0;
				IF (ActualPosition = TargetPosition AND ActualVelocity = TargetVelocity) THEN
					InPosition	:= TRUE;
					InVelocity	:= TRUE;
					AxisState	:= CheckCommand;
				END_IF;
			END_IF;
			
			
		WaitTargetPosition:
			
			IF (ActualPosition = NewSetPoint AND TGT_SENSOR) THEN
				InPosition	:= TRUE;
				AxisState	:= CheckCommand;
			END_IF;
			
			Timer := Timer	- 1;
			IF Timer = 0 THEN
				DeviceFault	:= TRUE;
				AxisState	:= FaultState;
			END_IF;
			

		WaitTargetVelocity:
			
			IF ActualVelocity = NewSetPoint THEN
				InVelocity	:= TRUE;
				AxisState	:= CheckCommand;
			END_IF;
			
			Timer := Timer	- 1;
			IF Timer = 0 THEN
				DeviceFault	:= TRUE;
				AxisState	:= FaultState;
			END_IF;
		
			
		FaultState:
			
			IF Reset THEN
				DeviceFault	:= FALSE;
				AxisState	:= CheckCommand;
			END_IF;
		
	END_CASE;
	
END_FUNCTION_BLOCK
