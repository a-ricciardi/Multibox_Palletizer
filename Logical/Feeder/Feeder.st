
PROGRAM _CYCLIC
	
	CASE State OF
		
		F_StopSequence:
			
			StartFeeder						:= FALSE;
			Conveyor_if_disable_request		:= TRUE;
			Conveyor_turn1_disable_request	:= TRUE;
			Conveyor_end_disable_request	:= TRUE;
			Carriage.Command				:= EMERGENCY_STOP_REQUEST;
			State							:= F_StopDONE;
			
	
			
		F_StopDONE:
			
			IF (NOT Conveyor_if_disable_request AND NOT Conveyor_turn1_disable_request AND NOT Conveyor_end_disable_request AND CarriagePositionReached) THEN
				Carriage.Command		:= IDLE;
				Feeder_EmergencyStop	:= FALSE;
				Feeder_ImmediateStop	:= FALSE;
				Feeder_OnPhaseStop		:= FALSE;
				StopRequest				:= TRUE;
				State					:= F_WaitStart;
			END_IF;
	
			
			
		F_ResetConfig:
			
			IF NOT Feeder_ResetConfig THEN
				State := F_WaitStart;
			END_IF;
			
			IF (CarriagePositionReached AND NOT Pusher_disable_request AND NOT Turnpusher_disable_request) THEN
				Carriage.Command	:= IDLE;
				SensorMemory[0]		:= FALSE;
				SensorMemory[1]		:= FALSE;
				SensorReached[0]	:= FALSE;
				SensorReached[1]	:= FALSE;
				
				FOR i:=0 TO 9 DO
					GD_StatusRequest[i]	:= FALSE;
				END_FOR;
				
				Feeder_ResetConfig  := FALSE;
				State := F_WaitStart;
			END_IF;
			
			
			
		F_RestoreConfig1:
			
			Carriage.Command := IDLE;
			
			FOR i:= 0 TO 9 DO
				IF GD_StatusRequest[i] THEN
					CASE i OF
						0:	Conveyor_if_enable_request		:= TRUE;
						1: 	Conveyor_if_disable_request		:= TRUE;
						2:	Conveyor_turn1_enable_request	:= TRUE;
						3: 	Conveyor_turn1_disable_request	:= TRUE;
						4:	Conveyor_end_enable_request		:= TRUE;
						5:	Conveyor_end_disable_request	:= TRUE;
						6:	Pusher_enable_request			:= TRUE;
						7: 	Pusher_disable_request			:= TRUE;
						8:	Turnpusher_enable_request		:= TRUE;
						9:	Turnpusher_disable_request		:= TRUE;
					END_CASE;	
				END_IF;
			END_FOR;
			
			Enable_Disable_Counter	:= 70;
			State					:= F_RestoreConfig2;
		
			
			
		F_RestoreConfig2:
			
			FOR i:= 0 TO 9 DO
				IF GD_StatusRequest[i] THEN
					CASE i OF
						
						0:	IF NOT Conveyor_if_enable_request  THEN
	  							GD_StatusRequest[i]	:= FALSE;
							END_IF;
							
						1: IF NOT Conveyor_if_disable_request  THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
							
						2:	IF NOT Conveyor_turn1_enable_request  THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
							
						3: 	IF NOT Conveyor_turn1_disable_request  THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
							
						4:	IF NOT Conveyor_end_enable_request  THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
							
						5:	IF NOT Conveyor_end_disable_request  THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
							
						6:	IF NOT Pusher_enable_request  THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
							
						7: 	IF NOT Pusher_disable_request  THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
							
						8:	IF NOT Turnpusher_enable_request  THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
							
						9:	IF NOT Turnpusher_disable_request  THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
						
					END_CASE;	
				END_IF;
			END_FOR;
			
			Enable_Disable_Counter	:= Enable_Disable_Counter - 1;
			
			IF Enable_Disable_Counter = 0 THEN
				
				IF CheckPosition THEN
					CarriageSetPoint	:= OldPosition;
					Carriage.Command	:= CHANGE_POSITION;
				END_IF;
				
				State := F_RestoreConfig3;
			END_IF;
		
		
			
		F_RestoreConfig3:
			
			IF (CarriagePositionReached AND CheckPosition) THEN
				Carriage.Command			:= IDLE;
				CarriagePositionRestored	:= TRUE;
			END_IF;
			
			IF (NOT CheckPosition OR CarriagePositionRestored) THEN
				StopRequest		:= FALSE;
				Feeder_Restart	:= FALSE;
				State			:= OldState;
			END_IF;

			
			
		F_WaitStart:
			
			IF Feeder_Restart THEN
				State := F_RestoreConfig1;
			END_IF;
			
			IF Feeder_ResetConfig THEN
				BoxCounter					:= 0;
				FeederReady					:= FALSE;
				CraneLayerCounter			:= FALSE;
				SecondLayer					:= FALSE;
				LoadBoxesOnCrane			:= FALSE;
				BoxesOnCrane				:= FALSE;
				Pusher_disable_request		:= TRUE;
				Turnpusher_disable_request	:= TRUE;
				CarriageSetPoint			:= 0;
				Carriage.Command			:= CHANGE_POSITION;
				State						:= F_ResetConfig;
			END_IF;
			
			IF (StartFeeder AND NOT Feeder_ResetConfig AND NOT Feeder_Restart) THEN
				Conveyor_if_enable_request	:= TRUE;
				State						:= F_WaitConveyorIFActive;
			END_IF;
			
			IF Feeder_EmergencyStop THEN
	  			State := F_StopSequence;
			END_IF;
			
			IF Feeder_ImmediateStop AND NOT StopRequest THEN
				OldState := State;
				State	 := F_StopSequence;
			END_IF;
			
			IF Feeder_ImmediateStop AND StopRequest THEN
				State	:= F_StopSequence;
			END_IF;

			
			
		F_WaitConveyorIFActive:
			
			IF NOT Conveyor_if_enable_request THEN
				State	:= F_WaitBoxPusherPosition;
			END_IF;
			
			IF Feeder_EmergencyStop THEN
				State	:= F_StopSequence;
			END_IF;
			
			IF Feeder_ImmediateStop THEN
				GD_StatusRequest[0]		  := TRUE; (* conveyor_if_EN *)
				OldState				  := State;
				State				   	  := F_StopSequence;
			END_IF;

		
			
		F_WaitBoxPusherPosition:
			
			IF (LaserSensor1 OR (SensorReached[0] AND SensorMemory[0])) THEN
				SensorReached[0]				:= FALSE;
				SensorMemory[0]					:= FALSE;
				Conveyor_if_disable_request		:= TRUE;
				Conveyor_turn1_enable_request	:= TRUE;                                                                                                                                       
				Conveyor_end_enable_request		:= TRUE;
				State							:= F_LayerCheck;
			END_IF;

			IF Feeder_EmergencyStop THEN
				State	:= F_StopSequence;
			END_IF;
			
			IF Feeder_ImmediateStop THEN
				SensorMemory[0]			  := TRUE; (* laser_sensor_IR *)
				GD_StatusRequest[0] 	  := TRUE; (* conveyor_if_EN *)
				OldState				  := State;
				State					  := F_StopSequence;
			END_IF;
			
		
			
		F_LayerCheck:
			
			IF (NOT Conveyor_if_disable_request AND NOT Conveyor_turn1_enable_request AND NOT Conveyor_end_enable_request) THEN
				
				IF NOT CraneLayerCounter THEN		(* 1st boxes layer *)
					IF BoxCounter < 8 THEN
						Turnpusher_disable_request	:= TRUE;
						Pusher_enable_request		:= TRUE;
						MainLine					:= TRUE;
						State						:= F_LineCheck;
					END_IF;
					
					IF BoxCounter >= 8 THEN
						Turnpusher_enable_request	:= TRUE;
						Pusher_enable_request	    := TRUE;
						MainLine					:= FALSE;
						State						:= F_LineCheck;
					END_IF;
				END_IF;
				
				IF CraneLayerCounter THEN		(* 2nd boxes layer *)
					IF BoxCounter < 6 THEN
						Turnpusher_enable_request	:= TRUE;
						Pusher_enable_request		:= TRUE;
						MainLine					:= FALSE;
						State						:= F_LineCheck;
					END_IF;
					
					IF BoxCounter >= 6 THEN
						Turnpusher_disable_request	:= TRUE;
						Pusher_enable_request		:= TRUE;
						MainLine					:= TRUE;
						State						:= F_LineCheck;
					END_IF;
				END_IF;
				
			END_IF;
			
			IF Feeder_EmergencyStop THEN
				State	:= F_StopSequence;
			END_IF;
			
			IF Feeder_ImmediateStop THEN
				GD_StatusRequest[1]	:= TRUE; (* conveyor_if_DIS *)
				GD_StatusRequest[2]	:= TRUE; (* conveyor_turn1_EN *)
				GD_StatusRequest[4]	:= TRUE; (* conveyor_end_EN *)
				OldState			:= State;
				State				:= F_StopSequence;
			END_IF;
		
		
			
		F_LineCheck:
			
			IF (NOT Turnpusher_disable_request AND NOT Pusher_enable_request AND MainLine) THEN
				Pusher_disable_request	:= TRUE;
				State					:= F_WaitLaser2;
			END_IF;
		
			IF (NOT Turnpusher_enable_request AND NOT Pusher_enable_request AND NOT MainLine) THEN
				Pusher_disable_request	:= TRUE;
				State					:= F_WaitLaser2;
			END_IF;

			IF Feeder_EmergencyStop THEN
				State	:= F_StopSequence;
			END_IF;
			
			IF Feeder_ImmediateStop THEN
				SensorMemory[1]		:= TRUE;
				GD_StatusRequest[2]	:= TRUE; (* conveyor_turn1_EN *)
				GD_StatusRequest[4]	:= TRUE; (* conveyor_end_EN *)
				GD_StatusRequest[6]	:= TRUE; (* pusher_EN *)
				
				IF MainLine THEN
					GD_StatusRequest[9]	:= TRUE; (* turnpusher_DIS *)
				END_IF;
				IF NOT MainLine THEN
					GD_StatusRequest[8]	:= TRUE; (* turnpusher_EN *)
				END_IF;
				
				OldState	:= State;
				State		:= F_StopSequence;
			END_IF;
			
		
			
		F_WaitLaser2:
			
			IF ((LaserSensor2 OR (SensorReached[1] AND SensorMemory[1])) AND NOT Pusher_disable_request) THEN
				SensorReached[1]	:= FALSE;
				SensorMemory[1]		:= FALSE;
				BoxCounter			:= BoxCounter + 1;
				State				:= F_BoxPosOk;
			END_IF;
			
			IF Feeder_EmergencyStop THEN
				State	:= F_StopSequence;
			END_IF;
			
			IF Feeder_ImmediateStop THEN
				SensorMemory[1]		:= TRUE;
				GD_StatusRequest[2]	:= TRUE; (* conveyor_turn1_EN *)
				GD_StatusRequest[4]	:= TRUE; (* conveyor_end_EN *)
				GD_StatusRequest[7]	:= TRUE; (* pusher_DIS *)
				OldState			:= State;
				State				:= F_StopSequence;
			END_IF;
			
		
			
		F_BoxPosOk:
			
			IF NOT CraneLayerCounter THEN		(* 1st boxes layer *)
				
				IF (BoxCounter = 8 OR BoxCounter = 11 OR BoxCounter = 14) THEN
					Conveyor_turn1_disable_request	:= TRUE;
					State							:= F_WaitConveyorStop;
				ELSE
					State							:= F_WaitStart;
				END_IF;
				
			END_IF;
			
			IF CraneLayerCounter THEN		(* 2nd boxes layer *)
				
				IF (BoxCounter = 3 OR BoxCounter = 6 OR BoxCounter = 14) THEN
					Conveyor_turn1_disable_request	:= TRUE;
					State							:= F_WaitConveyorStop;
				ELSE
					State							:= F_WaitStart;
				END_IF;
				
			END_IF;
			
			IF Feeder_EmergencyStop THEN
				State	:= F_StopSequence;
			END_IF;
			
			IF Feeder_ImmediateStop THEN
				GD_StatusRequest[2]	:= TRUE; (* conveyor_turn1_EN *)
				GD_StatusRequest[4]	:= TRUE; (* conveyor_end_EN *)
				OldState			:= State;
				State				:= F_StopSequence;
			END_IF;
		
			
			
		F_WaitConveyorStop:
			
			IF NOT Conveyor_turn1_disable_request THEN
				
				IF BoxCounter = 14 THEN
					State	:= F_Idle;
				END_IF;
				
				IF BoxCounter < 14 THEN
					EndLayer			:= FALSE;
					CarriageSetPoint	:= 0.44;
					Carriage.Command	:= CHANGE_POSITION;
					State				:= F_CarriageFwdPosition;
				END_IF;
				
			END_IF;
			
			IF Feeder_EmergencyStop THEN
				State	:= F_StopSequence;
			END_IF;
			
			IF Feeder_ImmediateStop THEN
				GD_StatusRequest[4]	:= TRUE; (* conveyor_end_EN *)
				GD_StatusRequest[3]	:= TRUE; (* conveyor_turn1_DIS *)
				OldState			:= State;
				State				:= F_StopSequence;
			END_IF;
		
			
			
		F_Idle:
			
			FeederReady	:= TRUE;
			
			IF CraneLayerCounter THEN		(* 2nd boxes layer *)
				SecondLayer	:= TRUE;
			END_IF;
			
			IF LoadBoxesOnCrane THEN
				EndLayer			:= TRUE;
				CraneLayerCounter	:= NOT CraneLayerCounter;
				CarriageSetPoint	:= 1.1;
				Carriage.Command	:= CHANGE_POSITION;		(* Axis command *)
				State				:= F_CarriageFwdPosition;
			END_IF;
			
			IF Feeder_EmergencyStop THEN
				State	:= F_StopSequence;
			END_IF;
			
			IF Feeder_ImmediateStop OR Feeder_OnPhaseStop THEN
				GD_StatusRequest[4]	:= TRUE; (* conveyor_end_EN *)
				OldState			:= State;
				State				:= F_StopSequence;
			END_IF;

			
			
		F_CarriageFwdPosition:
			
			IF (CarriagePositionReached OR CarriagePositionRestored) THEN
				CheckPosition			 := FALSE;
				CarriagePositionRestored := FALSE;
				Carriage.Command		 := IDLE;	(* Axis command *)
				State					 := F_CarriageBwdPosition;
			END_IF;
			
			IF Feeder_EmergencyStop THEN
				State	:= F_StopSequence;
			END_IF;
			
			IF Feeder_ImmediateStop THEN
				GD_StatusRequest[4]	:= TRUE; (* conveyor_end_EN *)
				
				IF EndLayer THEN
					CheckPosition	:= TRUE;
					OldPosition		:= 1.1;  (* old carriage position *)
				END_IF;
				IF NOT EndLayer THEN
					CheckPosition	:= TRUE;
					OldPosition		:= 0.44; (* old carriage position *)
				END_IF;
				
				OldState	:= State;
				State		:= F_StopSequence;
			END_IF;
		
			
			
		F_CarriageBwdPosition:
			
			IF 	NOT Carriage.InPosition THEN
				CarriageSetPoint	:= 0.0;
				Carriage.Command	:= CHANGE_POSITION;
				State				:= F_WaitStartPosition;
			END_IF;	
			
			IF Feeder_EmergencyStop THEN
				State	:= F_StopSequence;
			END_IF;
			
			IF Feeder_ImmediateStop THEN
				GD_StatusRequest[4]	:= TRUE; (* conveyor_end_EN *)
				OldState			:= State;
				State				:= F_StopSequence;
			END_IF;
		
			
			
		F_WaitStartPosition:	
			
			IF BoxCounter = 14 THEN
				BoxesOnCrane	:= TRUE;
				BoxCounter		:= 0;
			END_IF;
			
			IF (CarriagePositionReached OR CarriagePositionRestored) THEN
				CheckPosition		      := FALSE;
				CarriagePositionRestored  := FALSE;
				Carriage.Command		  := IDLE;
				State					  := F_WaitStart;
			END_IF;
		
			IF Feeder_EmergencyStop THEN
				State	:= F_StopSequence;
			END_IF;
		
			IF Feeder_ImmediateStop THEN
				GD_StatusRequest[4]  := TRUE; (* conveyor_end_EN *)
				CheckPosition		 := TRUE;
				OldPosition			 := 0; 	(* old carriage position *)
				OldState			 := State;
				State				 := F_StopSequence;
			END_IF;
		
	END_CASE;
	
	IF LaserSensor1 THEN
		SensorReached[0]	:= TRUE;
	END_IF;
	
	IF LaserSensor2 THEN
		SensorReached[1]	:= TRUE;
	END_IF;
	
	
	(*** Generic Devices ***)
	
	Conveyor_if.DeviceOperation 		 := OperationType;
	Conveyor_if.DeviceClock 			 := TRUE;
	Conveyor_if.DeviceDiagnosticsEnabled := TRUE;
	Conveyor_if.DeviceEnablePreset 		 := FALSE;
	Conveyor_if.DeviceEnableTime 		 := Conveyor_if_EnableTime;
	Conveyor_if.DeviceDisableTime 		 := Conveyor_if_DisableTime;
	Conveyor_if.DeviceType 				 := DEVICE_WITHOUT_FEEDBACK OR DEVICE_WITH_SINGLE_ACTUATION;
	Conveyor_if	( DeviceEnableRequest 	 := Conveyor_if_enable_request, 
				  DeviceDisableRequest 	 := Conveyor_if_disable_request );
	Feeder_ConveyorIF_Fwd 				 := Conveyor_if.EnableDevice;	(* single actuation *)
	act_ConveyorIFFault					 := SIMConveyorIFFault;

	
	Conveyor_turn1.DeviceOperation 			:= OperationType;
	Conveyor_turn1.DeviceClock 	   			:= TRUE;
	Conveyor_turn1.DeviceDiagnosticsEnabled := TRUE;
	Conveyor_turn1.DeviceEnablePreset 		:= FALSE;
	Conveyor_turn1.DeviceEnableTime 		:= Conveyor_turn1_EnableTime;
	Conveyor_turn1.DeviceDisableTime 		:= Conveyor_turn1_DisableTime;
	Conveyor_turn1.DeviceType 				:= DEVICE_WITHOUT_FEEDBACK OR DEVICE_WITH_SINGLE_ACTUATION;
	Conveyor_turn1	 ( DeviceEnableRequest  := Conveyor_turn1_enable_request,
					   DeviceDisableRequest := Conveyor_turn1_disable_request );
	Feeder_ConveyorTurn1_Fwd 				:= Conveyor_turn1.EnableDevice;	(* single actuation *)
	act_ConveyorTurn1Fault					:= SIMConveyorTurn1Fault;

	
	Pusher.DeviceOperation 			:= OperationType;
	Pusher.DeviceClock 				:= TRUE;
	Pusher.DeviceDiagnosticsEnabled := TRUE;
	Pusher.DeviceEnablePreset 		:= FALSE;
	Pusher.DeviceEnabledSensor 		:= Pusher_FWD; (* double feedback *)
	Pusher.DeviceDisabledSensor 	:= Pusher_BKW; (* double feedback *)
	Pusher.DeviceEnableTime 		:= PusherEnableTime;
	Pusher.DeviceDisableTime 		:= PusherDisableTime;
	Pusher.DeviceType 				:= DEVICE_WITH_DOUBLE_FEEDBACK OR DEVICE_WITH_SINGLE_ACTUATION;
	Pusher   ( DeviceEnableRequest  := Pusher_enable_request,
			   DeviceDisableRequest := Pusher_disable_request );
	Feeder_PusherFwd 				:= Pusher.EnableDevice;	(* single actuation *)
	act_FeederPusherFault 			:= SIMFeederPusherFault;

	
	Conveyor_end.DeviceOperation 			:= OperationType;
	Conveyor_end.DeviceClock 				:= TRUE;
	Conveyor_end.DeviceDiagnosticsEnabled 	:= TRUE;
	Conveyor_end.DeviceEnablePreset 		:= FALSE;
	Conveyor_end.DeviceEnableTime 			:= Conveyor_end_EnableTime;
	Conveyor_end.DeviceDisableTime 			:= Conveyor_end_DisableTime;
	Conveyor_end.DeviceType 				:= DEVICE_WITHOUT_FEEDBACK OR DEVICE_WITH_SINGLE_ACTUATION;
	Conveyor_end     ( DeviceEnableRequest  := Conveyor_end_enable_request,
		               DeviceDisableRequest := Conveyor_end_disable_request );
	Feeder_ConveyorEndFwd 					:= Conveyor_end.EnableDevice;	(* single actuation *)
	act_ConveyorEndFault					:= SIMConveyorEndFault;
	
	
	Turnpusher.DeviceOperation 			:= OperationType;
	Turnpusher.DeviceClock 				:= TRUE;
	Turnpusher.DeviceDiagnosticsEnabled := TRUE;
	Turnpusher.DeviceEnablePreset 		:= FALSE;
	Turnpusher.DeviceEnabledSensor 		:= Turnpusher_BWD; (* double feedback *)
	Turnpusher.DeviceDisabledSensor 	:= Turnpusher_FWD; (* double feedback *)
	Turnpusher.DeviceEnableTime 		:= TurnpusherEnableTime;
	Turnpusher.DeviceDisableTime 		:= TurnpusherDisableTime;
	Turnpusher.DeviceType 				:= DEVICE_WITH_DOUBLE_FEEDBACK OR DEVICE_WITH_DOUBLE_ACTUATION;
	Turnpusher   ( DeviceEnableRequest  := Turnpusher_enable_request,
		           DeviceDisableRequest := Turnpusher_disable_request );
	Feeder_TurnpusherBwd 				:= Turnpusher.EnableDevice;		(* double actuation *)
	Feeder_TurnpusherFwd 				:= Turnpusher.DisableDevice;	(* double actuation *)
	act_TurnpusherFault 				:= SIMTurnpusherFault;

	
	(*** Generic Axis ***)
	
	Carriage.NewSetPoint		:= CarriageSetPoint;
	Carriage.ActualPosition		:= Feeder_Carriage_Axis;
	Carriage.TGT_SENSOR			:= Feeder_Carriage_Reached;
	Feeder_Carriage_Axis_TgtPos	:= Carriage.TargetPosition;
	CarriagePositionReached		:= Carriage.InPosition;
	Carriage.DeviceTimer		:= 400;
	act_CarriageFault			:= SIMCarriageFault;
	Carriage();	
	 
END_PROGRAM