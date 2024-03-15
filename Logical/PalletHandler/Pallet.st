
PROGRAM _CYCLIC

	CASE State OF
		
		
		P_StopSequence:
			
			StartPallet				    	:= FALSE;
			PalletConveyor1_disable_request	:= TRUE;
			PalletLifter.Command			:= EMERGENCY_STOP_REQUEST;
			PalletConveyor2.Command			:= EMERGENCY_STOP_REQUEST;
			State							:= P_StopDONE;
		
			
			
		P_StopDONE:
			
			IF (NOT PalletConveyor1_disable_request AND PalletLifterPositionReached AND PalletConveyor2VelocityReached) THEN
				PalletLifter.Command	:= IDLE;
				PalletConveyor2.Command	:= IDLE;
				Pallet_EmergencyStop	:= FALSE;
				Pallet_ImmediateStop	:= FALSE;
				Pallet_OnPhaseStop		:= FALSE;
				StopRequest				:= TRUE;
				State					:= P_WaitStart;
			END_IF;
			
			
			
		P_ResetConfig1:
			
			IF NOT Pallet_ResetConfig THEN
				State	:= P_WaitStart;
			END_IF;
			
			IF PalletLifterPositionReached THEN
				PalletLifter.Command	   := IDLE;
				PalletFork_disable_request := TRUE; (* fork closed *)
				State					   := P_ResetConfig2;
			END_IF;
			
			
			
		P_ResetConfig2:
			
			IF NOT PalletFork_disable_request THEN
				PalletLifterSetPoint	:= 0; (* idle position *)
				PalletLifter.Command	:= CHANGE_POSITION;
				State					:= P_ResetConfig3;
			END_IF;
			
			
			
		P_ResetConfig3:
			
			IF PalletLifterPositionReached THEN
				PalletLifter.Command := IDLE;
				
				FOR i := 0 TO 3 DO
					GD_StatusRequest[i] := FALSE;
				END_FOR;
				
				Pallet_ResetConfig := FALSE;
				State			   := P_WaitStart;
			END_IF;
			
			
	
		P_RestoreConfig1:
			
			PalletLifter.Command	:= IDLE;
			PalletConveyor2.Command	:= IDLE;
			
			FOR i := 0 TO 3 DO
				IF GD_StatusRequest[i] THEN
					CASE i OF
						0:	PalletFork_enable_request		:= TRUE;
						1:	PalletFork_disable_request		:= TRUE;
						2:	PalletConveyor1_enable_request	:= TRUE;
						3:	PalletConveyor1_disable_request	:= TRUE;
					END_CASE;
				END_IF;
			END_FOR;
			
			Enable_Disable_Counter	:= 70;
			State					:= P_RestoreConfig2;
			
			
		
		P_RestoreConfig2:
			
			FOR i := 0 TO 3 DO
				IF GD_StatusRequest[i] THEN
					CASE i OF
						0: IF NOT PalletFork_enable_request THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
							
						1: IF NOT PalletFork_disable_request THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
							
						2: IF NOT PalletConveyor1_enable_request THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
							
						3: IF NOT PalletConveyor1_disable_request THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
					END_CASE;
				END_IF;
			END_FOR;
			
			Enable_Disable_Counter	:= Enable_Disable_Counter - 1;
			
			IF Enable_Disable_Counter = 0 THEN
				IF CheckPosition THEN
					PalletLifterSetPoint	:= OldPosition;
					PalletLifter.Command	:= CHANGE_POSITION;
				END_IF;
				
				IF CheckVelocity THEN
					PalletConveyor2SetPoint	:= OldVelocity;
					PalletConveyor2.Command	:= CHANGE_VELOCITY;
				END_IF;
				
				State	:= P_RestoreConfig3;
			END_IF;
			
			
			
		P_RestoreConfig3:
			
			IF (PalletLifterPositionReached AND CheckPosition) THEN
				PalletLifterPositionRestored := TRUE;
				PalletLifter.Command		 := IDLE;
			END_IF;
			
			IF (PalletConveyor2VelocityReached AND CheckVelocity) THEN
				PalletConveyor2VelocityRestored	:= TRUE;
				PalletConveyor2.Command			:= IDLE;
			END_IF;
		
			IF (NOT CheckPosition OR PalletLifterPositionReached) AND (NOT CheckVelocity OR PalletConveyor2VelocityReached) THEN
				StopRequest		:= FALSE;
				Pallet_Restart	:= FALSE;
				State			:= OldState;
			END_IF;

						
			
		P_WaitStart:
			
			IF Pallet_Restart THEN
				State	:= P_RestoreConfig1;
			END_IF;
			
			IF Pallet_ResetConfig THEN
				PalletCounter	:= 5;
				PalletReady		:= FALSE;
				PalletExit_EN	:= FALSE;
				PalletExit_DONE	:= FALSE;
				
				IF PalletFork.DeviceDisabled THEN (* fork closed *)
					PalletLifterSetPoint := 0; (* idle position *)
					PalletLifter.Command := CHANGE_POSITION;
					State				 := P_ResetConfig3;
				ELSE (* fork opened *)
					PalletLifterSetPoint := -0.258;
					PalletLifter.Command := CHANGE_POSITION;
					State				 := P_ResetConfig1;
				END_IF;
				
			END_IF;
			
			IF (StartPallet AND NOT Pallet_ResetConfig AND NOT Pallet_Restart) THEN
				PalletLifterSetPoint := -0.258;
				PalletLifter.Command := CHANGE_POSITION;
				State				 := P_WaitLifterDown;
			END_IF;

			IF Pallet_EmergencyStop THEN
				State := P_StopSequence;
			END_IF;
			
			IF Pallet_ImmediateStop AND NOT StopRequest THEN
				IF PalletOnConveyor2 THEN
					CheckVelocity		:= TRUE;
					OldVelocity			:= 0.5;  (* old conveyor 2 velocity *) //0.3
					PalletOnConveyor2	:= FALSE;
				END_IF;
				
				OldState	:= State;
				State		:= P_StopSequence;
			END_IF;
			
			IF Pallet_ImmediateStop AND StopRequest THEN
				State	:= P_StopSequence;
			END_IF;
			
			
			
		P_WaitLifterDown:
			
			IF (PalletLifterPositionReached OR PalletLifterPositionRestored) THEN
				CheckPosition				 := FALSE;
				PalletLifterPositionRestored := FALSE;
				PalletLifter.Command		 := IDLE;
				PalletFork_enable_request	 := TRUE;
				State						 := P_ForkOpen;
			END_IF;
			
			IF Pallet_EmergencyStop THEN
				State := P_StopSequence;
			END_IF;
			
			IF Pallet_ImmediateStop OR Pallet_OnPhaseStop THEN
				IF PalletOnConveyor2 THEN
					CheckVelocity	  := TRUE;
					OldVelocity		  := 0.5; (* old conveyor 2 velocity *) //0.3
					PalletOnConveyor2 := FALSE;
				END_IF;
				
				CheckPosition	:= TRUE;
				OldPosition		:= -0.258; (* old pallet lifter position *)
				OldState		:= State;
				State			:= P_StopSequence;
			END_IF;
				
			
			
		P_ForkOpen:
			
			IF NOT PalletFork_enable_request THEN
				PalletLifterSetPoint := -0.12;
				PalletLifter.Command := CHANGE_POSITION;
				State				 := P_WaitLifterUp;
			END_IF;
			
			IF Pallet_EmergencyStop THEN
				State := P_StopSequence;
			END_IF;
			
			IF Pallet_ImmediateStop THEN
				IF PalletOnConveyor2 THEN
					CheckVelocity 	  := TRUE;
					OldVelocity	  	  := 0.5; (* old conveyor 2 velocity *) //0.3
					PalletOnConveyor2 := FALSE;
				END_IF;
				
				GD_StatusRequest[0] := TRUE; (* pallet fork EN *)
				OldState			:= State;
				State				:= P_StopSequence;
			END_IF;
		
			
			
		P_WaitLifterUp:
			
			IF (PalletLifterPositionReached OR PalletLifterPositionRestored) THEN
				CheckPosition				 := FALSE;
				PalletLifterPositionRestored := FALSE;
				PalletLifter.Command		 := IDLE;
				PalletFork_disable_request	 := TRUE;
				State						 := P_ForkClose;
			END_IF;
			
			IF Pallet_EmergencyStop THEN
				State := P_StopSequence;
			END_IF;
			
			IF Pallet_ImmediateStop THEN
				CheckPosition := TRUE;
				OldPosition	  := -0.12; (* old pallet lifter position *)
				OldState	  := State;
				State	      := P_StopSequence;
			END_IF;
			
			
			
		P_ForkClose:
			
			IF NOT PalletFork_disable_request  THEN
				PalletLifterSetPoint := 0.0;
				PalletLifter.Command := CHANGE_POSITION;
				State				 := P_WaitLifterIdle;
			END_IF;
			
			IF Pallet_EmergencyStop THEN
				State := P_StopSequence;
			END_IF;
			
			IF Pallet_ImmediateStop THEN
				GD_StatusRequest[1] := TRUE; (* pallet fork DIS *)
				OldState			:= State;
				State				:= P_StopSequence;
			END_IF;
		
			
			
		P_WaitLifterIdle:
			
			IF (PalletLifterPositionReached OR PalletLifterPositionRestored) THEN
				CheckPosition				 	:= FALSE;
				PalletLifterPositionRestored 	:= FALSE;
				PalletLifter.Command		 	:= IDLE;
				PalletCounter				 	:= PalletCounter -1;
				PalletConveyor1_enable_request	:= TRUE;
				State							:= P_WaitConveyor1;
			END_IF;
			
			IF Pallet_EmergencyStop THEN
				State := P_StopSequence;
			END_IF;
			
			IF Pallet_ImmediateStop THEN
				CheckPosition	:= TRUE;
				OldPosition		:= 0.0; (* old pallet lifter position *)
				OldState		:= State;
				State			:= P_StopSequence;
			END_IF;
			
			
			
		P_WaitConveyor1:
			
			IF NOT PalletConveyor1_enable_request THEN
				PalletConveyor2SetPoint	:= 0.5;
				PalletConveyor2.Command	:= CHANGE_VELOCITY;
				State					:= P_WaitConveyor2;
			END_IF;
			
			IF Pallet_EmergencyStop THEN
				State := P_StopSequence;
			END_IF;
			
			IF Pallet_ImmediateStop THEN
				GD_StatusRequest[2] := TRUE; (* pallet conveyor 1 EN *)
				OldState			:= State;
				State				:= P_StopSequence;
			END_IF;
		
			
			
		P_WaitConveyor2:
			
			IF (PalletConveyor2VelocityReached OR PalletConveyor2VelocityRestored) THEN
				CheckVelocity					:= FALSE;
				PalletConveyor2VelocityRestored	:= FALSE;
				PalletConveyor2.Command			:= IDLE;
				State							:= P_WaitLightBarrier2;
			END_IF;
			
			IF Pallet_EmergencyStop THEN
				State	:= P_StopSequence;
			END_IF;
			
			IF Pallet_ImmediateStop THEN
				GD_StatusRequest[2] := TRUE; (* pallet conveyor 1 EN *)
				CheckVelocity		:= TRUE;
				OldVelocity			:= 0.5;  (* old conveyor 2 velocity *)
				OldState			:= State;
				State				:= P_StopSequence;
			END_IF;
			
			
			
		P_WaitLightBarrier2:
			
			IF LightBarrier2 AND (PalletConveyor2VelocityRestored OR NOT CheckVelocity) THEN
				CheckVelocity					:= FALSE;
				PalletConveyor2VelocityRestored	:= FALSE;
				PalletConveyor1_disable_request	:= TRUE;
				State							:= P_WaitStopConveyor1;
			END_IF;
			
			IF Pallet_EmergencyStop THEN
				State := P_StopSequence;
			END_IF;
			
			IF Pallet_ImmediateStop THEN
				GD_StatusRequest[2] := TRUE; (* pallet conveyor 1 EN *)
				CheckVelocity		:= TRUE;
				OldVelocity			:= 0.5; (* old conveyor 2 velocity *)
				OldState			:= State;
				State				:= P_StopSequence;
			END_IF;
			
			
			
		P_WaitStopConveyor1:
						
			IF NOT PalletConveyor1_disable_request AND (PalletConveyor2VelocityRestored OR NOT CheckVelocity) THEN
				CheckVelocity					:= FALSE;
				PalletConveyor2VelocityRestored	:= FALSE;
				PalletConveyor2SetPoint			:= 0.1;
				PalletConveyor2.Command			:= CHANGE_VELOCITY;
				State							:= P_WaitConveyor2SlowDown;
			END_IF;
			
			IF Pallet_EmergencyStop THEN
				State := P_StopSequence;
			END_IF;
			
			IF Pallet_ImmediateStop THEN
				CheckVelocity			  := TRUE;
				OldVelocity				  := 0.5;  (* old conveyor 2 velocity *)
				GD_StatusRequest[3] 	  := TRUE; (* pallet conveyor 1 DIS *)
				OldState				  := State;
				State					  := P_StopSequence;
			END_IF;
	
		
		
		P_WaitConveyor2SlowDown:
			
			IF (PalletConveyor2VelocityReached OR PalletConveyor2VelocityRestored) THEN
				CheckVelocity					:= FALSE;
				PalletConveyor2VelocityRestored	:= FALSE;
				PalletConveyor2.Command			:= IDLE;
				State							:= P_WaitLightBarrier1;
			END_IF;
			
			IF Pallet_EmergencyStop THEN
				State := P_StopSequence;
			END_IF;
			
			IF Pallet_ImmediateStop THEN
				CheckVelocity			  := TRUE;
				OldVelocity				  := 0.1;  (* old conveyor 2 velocity *)
				GD_StatusRequest[3] 	  := TRUE; (* pallet conveyor 1 DIS *)
				OldState				  := State;
				State					  := P_StopSequence;
			END_IF;
		
			
			
		P_WaitLightBarrier1:
			
			IF LightBarrier1 AND (PalletConveyor2VelocityRestored OR NOT CheckVelocity) THEN
				CheckVelocity					:= FALSE;
				PalletConveyor2VelocityRestored	:= FALSE;
				PalletConveyor2SetPoint			:= 0.0;
				PalletConveyor2.Command			:= CHANGE_VELOCITY;
				State							:= P_WaitStopConveyor2;
			END_IF;
			
			IF Pallet_EmergencyStop THEN
				State := P_StopSequence;
			END_IF;
			
			IF Pallet_ImmediateStop THEN
				CheckVelocity := TRUE;
				OldVelocity	  := 0.1;  (* old conveyor 2 velocity *)
				OldState	  := State;
				State		  := P_StopSequence;
			END_IF;
			
			
			
		P_WaitStopConveyor2:
			
			IF (PalletConveyor2VelocityReached OR PalletConveyor2VelocityRestored) THEN
				CheckVelocity					:= FALSE;
				PalletConveyor2VelocityRestored	:= FALSE;
				PalletConveyor2.Command			:= IDLE;
				PalletReady						:= TRUE;
				State							:= P_WaitBoxes;
			END_IF;
			
			IF Pallet_EmergencyStop THEN
				State := P_StopSequence;
			END_IF;
			
			IF Pallet_ImmediateStop THEN
				CheckVelocity := TRUE;
				OldVelocity	  := 0.0; (* old conveyor 2 velocity *)
				OldState	  := State;
				State		  := P_StopSequence;
			END_IF;

			
			
		P_WaitBoxes:
			
			IF PalletExit_EN THEN
				PalletConveyor2SetPoint	:= 0.3;
				PalletConveyor2.Command	:= CHANGE_VELOCITY;
				State					:= P_WaitRestartConveyor2;
			END_IF;
			
			IF Pallet_EmergencyStop THEN
				State := P_StopSequence;
			END_IF;
			
			IF Pallet_ImmediateStop OR Pallet_OnPhaseStop THEN
				OldState := State;
				State	 := P_StopSequence;
			END_IF;
		
			
			
		P_WaitRestartConveyor2:
			
			IF (PalletConveyor2VelocityReached OR PalletConveyor2VelocityRestored) THEN
				CheckVelocity					:= FALSE;
				PalletConveyor2VelocityRestored	:= FALSE;
				PalletConveyor2.Command			:= IDLE;
				State							:= P_WaitNOTLightBarrier2;
			END_IF;
			
			IF Pallet_EmergencyStop THEN
				State	:= P_StopSequence;
			END_IF;
			
			IF Pallet_ImmediateStop THEN
				CheckVelocity := TRUE;
				OldVelocity	  := 0.3;  (* old conveyor 2 velocity *)
				OldState	  := State;
				State	      := P_StopSequence;
			END_IF;
			
			
			
		P_WaitNOTLightBarrier2:
			
			IF NOT LightBarrier2 AND (PalletConveyor2VelocityRestored OR NOT CheckVelocity) THEN
				CheckVelocity					:= FALSE;
				PalletConveyor2VelocityRestored	:= FALSE;
				PalletConveyor2SetPoint			:= 0.5;
				PalletConveyor2.Command			:= CHANGE_VELOCITY;
				State							:= P_WaitExitVelocity;
			END_IF;
			
			IF Pallet_EmergencyStop THEN
				State	:= P_StopSequence;
			END_IF;
			
			IF Pallet_ImmediateStop THEN
				CheckVelocity := TRUE;
				OldVelocity	  := 0.3; (* old conveyor 2 velocity *)
				OldState	  := State;
				State	      := P_StopSequence;
			END_IF;
		
			
			
		P_WaitExitVelocity:
			
			IF (PalletConveyor2VelocityReached OR PalletConveyor2VelocityRestored) THEN
				CheckVelocity					:= FALSE;
				PalletConveyor2VelocityRestored	:= FALSE;
				PalletConveyor2.Command			:= IDLE;
				PalletOnConveyor2				:= TRUE;
				PalletExit_DONE					:= TRUE;
				State							:= P_WaitStart;
			END_IF;
		
			IF Pallet_EmergencyStop THEN
				State	:= P_StopSequence;
			END_IF;
		
			IF Pallet_ImmediateStop THEN
				CheckVelocity	:= TRUE;
				OldVelocity		:= 0.5; (* old conveyor 2 velocity *)
				OldState		:= State;
				State			:= P_StopSequence;
			END_IF;
		
	END_CASE;
	
	
	(*** Generic Devices ***)
	
	PalletFork.DeviceOperation  		:= OperationType;
	PalletFork.DeviceClock 				:= TRUE;
	PalletFork.DeviceDiagnosticsEnabled := TRUE;
	PalletFork.DeviceEnablePreset 		:= FALSE;
	PalletFork.DeviceEnabledSensor 		:= Pallet_ForkFB;  (* enable feedback *)
	PalletFork.DeviceEnableTime 		:= PalletForkEnableTime;
	PalletFork.DeviceDisableTime 		:= PalletForkDisableTime;
	PalletFork.DeviceType 				:= DEVICE_WITH_ENABLE_FEEDBACK OR DEVICE_WITH_SINGLE_ACTUATION;
	PalletFork	 ( DeviceEnableRequest  := PalletFork_enable_request,
		           DeviceDisableRequest := PalletFork_disable_request );
	Pallet_Fork_EN		 				:= PalletFork.EnableDevice;  (* single actuation *)
	act_PalletForkFault 				:= SIMPalletForkFault;
	
	
	PalletConveyor1.DeviceOperation 		 := OperationType;
	PalletConveyor1.DeviceClock 			 := TRUE;
	PalletConveyor1.DeviceDiagnosticsEnabled := TRUE;
	PalletConveyor1.DeviceEnablePreset 		 := FALSE;
	PalletConveyor1.DeviceEnableTime 		 := PalletConveyor1EnableTime;
	PalletConveyor1.DeviceDisableTime 	     := PalletConveyor1DisableTime;
	PalletConveyor1.DeviceType 				 := DEVICE_WITHOUT_FEEDBACK OR DEVICE_WITH_SINGLE_ACTUATION;
	PalletConveyor1   ( DeviceEnableRequest  := PalletConveyor1_enable_request,
		                DeviceDisableRequest := PalletConveyor1_disable_request );
	Pallet_Conveyor1_Fwd 					 := PalletConveyor1.EnableDevice;	(* single actuation *)
	act_PalletConveyor1Fault				 := SIMPalletConveyor1Fault;
	
	
	(*** Generic Axes ***)
	
	PalletLifter.NewSetPoint	:= PalletLifterSetPoint;
	PalletLifter.ActualPosition	:= Pallet_Lifter_Axis;
	PalletLifter.TGT_SENSOR		:= TRUE;
	Pallet_Lifter_Axis_TgtPos 	:= PalletLifter.TargetPosition;
	PalletLifterPositionReached	:= PalletLifter.InPosition;
	PalletLifter.DeviceTimer	:= 400;
	act_PalletLifterFault		:= SIMPalletLifterFault;
	PalletLifter();
	
	PalletConveyor2.NewSetPoint		:= PalletConveyor2SetPoint;
	PalletConveyor2.ActualVelocity	:= Pallet_Conveyor2_ActVel;
	Pallet_Conveyor2_ActVel			:= PalletConveyor2.TargetVelocity;
	PalletConveyor2VelocityReached	:= PalletConveyor2.InVelocity;
	PalletConveyor2.DeviceTimer		:= 400;
	act_PalletConveyor2Fault		:= SIMPalletConveyor2Fault;
	PalletConveyor2();
	
END_PROGRAM