
PROGRAM _CYCLIC


	CASE State OF
		
		
		C_StopSequence:
			
			StartCrane			:= FALSE;
			GantryCrane.Command	:= EMERGENCY_STOP_REQUEST;
			BoxCrane.Command	:= EMERGENCY_STOP_REQUEST;
			State				:= C_StopDONE;
		
			
			
		C_StopDONE:
			
			IF (GantryCranePositionReached AND BoxCranePositionReached) THEN
				GantryCrane.Command	 := IDLE;
				BoxCrane.Command	 := IDLE;
				Crane_EmergencyStop  := FALSE;
				Crane_ImmediateStop  := FALSE;
				Crane_OnPhaseStop	 := FALSE;
				StopRequest			 := TRUE;
				State				 := C_WaitStart;
			END_IF;
			
			
			
		C_ResetConfig:
			
			IF NOT Crane_ResetConfig THEN
				State	:= C_WaitStart;
			END_IF;
			
			IF (GantryCranePositionReached AND BoxCranePositionReached AND NOT SlideRail_disable_request 
				AND NOT PusherZ_enable_request AND NOT PusherX_enable_request AND NOT Vacuum_disable_request 
				AND NOT Cartboard_disable_request) THEN
			
				GantryCrane.Command	:= IDLE;
				BoxCrane.Command	:= IDLE;
				
				FOR i := 0 TO 9 DO
					GD_StatusRequest[i]	:= FALSE;
				END_FOR;
				
				Crane_ResetConfig := FALSE;
				State			  := C_WaitStart;
				
			END_IF;
			
			
			
		C_RestoreConfig1:
			
			GantryCrane.Command	:= IDLE;
			BoxCrane.Command	:= IDLE;
			
			FOR i := 0 TO 9 DO
				IF GD_StatusRequest[i] THEN
					CASE i OF
						0:	Vacuum_enable_request	  := TRUE;
						1:	Vacuum_disable_request	  := TRUE;
						2:	Cartboard_enable_request  := TRUE;
						3:	Cartboard_disable_request := TRUE;
						4:	SlideRail_enable_request  := TRUE;
						5:	SlideRail_disable_request := TRUE;
						6:	PusherZ_enable_request	  := TRUE;
						7:	PusherZ_disable_request	  := TRUE;
						8:	PusherX_enable_request	  := TRUE;
						9:	PusherX_disable_request	  := TRUE;
					END_CASE;
				END_IF;
			END_FOR;
			
			Enable_Disable_Counter	:= 70;
			State					:= C_RestoreConfig2;
			
			
		
		C_RestoreConfig2:
			
			FOR i := 0 TO 9 DO
				IF GD_StatusRequest[i] THEN
					CASE i OF
						
						0:  IF NOT Vacuum_enable_request THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
							
						1:  IF NOT Vacuum_disable_request THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
							
						2:  IF NOT Cartboard_enable_request THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF
							
						3:  IF NOT Cartboard_disable_request THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
						
						4:	IF NOT SlideRail_enable_request THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
							
						5:  IF NOT SlideRail_disable_request THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
							
						6:  IF NOT PusherZ_enable_request THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
							
						7:  IF NOT PusherZ_disable_request THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
							
						8:  IF NOT PusherX_enable_request THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;
							
						9:  IF NOT PusherX_disable_request THEN
								GD_StatusRequest[i]	:= FALSE;
							END_IF;		
						
					END_CASE;
				END_IF;
			END_FOR;
			
			Enable_Disable_Counter	:= Enable_Disable_Counter - 1;
			
			IF Enable_Disable_Counter = 0 THEN
				
				IF CheckPosition[0] THEN
					GantryCraneSetPoint	:= OldPosition[0];
					GantryCrane.Command	:= CHANGE_POSITION;
				END_IF;
				
				IF CheckPosition[1] THEN
					BoxCraneSetPoint	:= OldPosition[1];
					BoxCrane.Command	:= CHANGE_POSITION;
				END_IF;
				
				State	:= C_RestoreConfig3;
			END_IF;
			
			
			
		C_RestoreConfig3:
			
			IF (GantryCranePositionReached AND CheckPosition[0]) THEN
				GantryCranePositionRestored	:= TRUE;
				GantryCrane.Command			:= IDLE;
			END_IF;
			
			IF (BoxCranePositionReached AND CheckPosition[1]) THEN
				BoxCranePositionRestored := TRUE;
				BoxCrane.Command		 := IDLE;
			END_IF;
			
			IF (NOT CheckPosition[0] OR GantryCranePositionRestored) AND (NOT CheckPosition[1] OR BoxCranePositionRestored) THEN
				StopRequest	   := FALSE;
				Crane_Restart  := FALSE;
				State		   := OldState;
			END_IF;			
			 
			
			
		C_WaitStart:
			
			IF Crane_Restart THEN
	  			State := C_RestoreConfig1;
			END_IF;
			
			IF Crane_ResetConfig THEN
				CraneCartboardCounter	  := 28;
				CraneReady				  := FALSE;
				HoldBoxes				  := FALSE;
				LoadBoxesOnPallet		  := FALSE;
				BoxesOnPallet			  := FALSE;
				SlideRail_disable_request := TRUE;
				PusherZ_enable_request	  := TRUE; (* pusher down *)
				PusherX_enable_request	  := TRUE; (* pusher forward *)
				Vacuum_disable_request	  := TRUE;
				Cartboard_disable_request := TRUE;
				GantryCraneSetPoint		  := 0;
				GantryCrane.Command	      := CHANGE_POSITION;
				BoxCraneSetPoint	      := 0;
				BoxCrane.Command	      := CHANGE_POSITION;
				State	                  := C_ResetConfig;
			END_IF;
			
			IF (StartCrane AND NOT Crane_ResetConfig AND NOT Crane_Restart) THEN
				GantryCraneSetPoint	 := 0;
				GantryCrane.Command	 := CHANGE_POSITION;
				State				 := C_WaitGantryCraneStartPosition;
			END_IF;
			
			IF Crane_EmergencyStop THEN
				State	:= C_StopSequence;
			END_IF;
			
			IF Crane_ImmediateStop AND NOT StopRequest THEN
				OldState := State;
				State	 := C_StopSequence; 
			END_IF;
			
			IF Crane_ImmediateStop AND StopRequest THEN
				State	:= C_StopSequence;
			END_IF;
			
			
			
		C_WaitGantryCraneStartPosition:
			
			IF (GantryCranePositionReached OR GantryCranePositionRestored) THEN
				CheckPosition[0]			:= FALSE;
				GantryCranePositionRestored	:= FALSE;
				GantryCrane.Command			:= IDLE;
				BoxCraneSetPoint			:= -0.195;
				BoxCrane.Command			:= CHANGE_POSITION;
				State						:= C_WaitCartboardLoadPosition;
			END_IF;
			
			IF Crane_EmergencyStop THEN
				State	:= C_StopSequence;
			END_IF;
			
			IF Crane_ImmediateStop THEN
				CheckPosition[0] := TRUE;
				OldPosition[0]	 := 0;  (* old Gantry Position *)
				OldState		 := State;
				State			 := C_StopSequence; 
			END_IF;
			
			
			
		C_WaitCartboardLoadPosition:
			
			IF (BoxCranePositionReached OR BoxCranePositionRestored) THEN
				CheckPosition[1]		 := FALSE;
				BoxCranePositionRestored := FALSE;
				BoxCrane.Command		 := IDLE;
				Vacuum_enable_request	 := TRUE;
				Cartboard_enable_request := TRUE;
				State					 := C_WaitCartboardLoad;
			END_IF;
			
			IF Crane_EmergencyStop THEN
				State	:= C_StopSequence;
			END_IF;
			
			IF Crane_ImmediateStop THEN
				CheckPosition[1] := TRUE;
				OldPosition[1]	 := -0.195;  (* old Box Position *)
				OldState		 := State;
				State			 := C_StopSequence; 
			END_IF;
			
		
			
		C_WaitCartboardLoad:
			
			IF (NOT Vacuum_enable_request AND NOT Cartboard_enable_request) THEN
				BoxCraneSetPoint	:= 0;
				BoxCrane.Command	:= CHANGE_POSITION;
	  			State				:= C_WaitBoxCraneStartPosition;
			END_IF;
			
			IF Crane_EmergencyStop THEN
				State := C_StopSequence;
			END_IF;
			
			IF Crane_ImmediateStop THEN
				GD_StatusRequest[0] := TRUE; (* vacuumEN *)
				GD_StatusRequest[2] := TRUE; (* cartboardEN *)
				OldState		    := State;
				State				:= C_StopSequence; 
			END_IF;
		
		
			
		C_WaitBoxCraneStartPosition:
			
			IF (BoxCranePositionReached OR BoxCranePositionRestored)THEN
				CheckPosition[1]		 := FALSE;
				BoxCranePositionRestored := FALSE;
				BoxCrane.Command		 := IDLE;
				PusherZ_enable_request 	 := TRUE; (* pusher down *)
				State					 := C_WaitPusherZStartDown;
			END_IF;
			
			IF Crane_EmergencyStop THEN
				State	:= C_StopSequence;
			END_IF;
			
			IF Crane_ImmediateStop THEN
				CheckPosition[1] := TRUE;
				OldPosition[1]	 := 0;  (* old Box Position *)
				OldState		 := State;
				State			 := C_StopSequence; 
			END_IF;
		
			
			
		C_WaitPusherZStartDown:
			
			IF NOT PusherZ_enable_request THEN
				PusherX_enable_request := TRUE; (* pusher forward *)
				State				   := C_WaitPusherXStartFwd;
			END_IF;
			
			IF Crane_EmergencyStop THEN
				State	:= C_StopSequence;
			END_IF;
			
			IF Crane_ImmediateStop THEN
				GD_StatusRequest[6] := TRUE; (* PusherZ_EN *)
				OldState			:= State;
				State				:= C_StopSequence; 
			END_IF;
			
			
			
		C_WaitPusherXStartFwd:
			
			IF NOT PusherX_enable_request THEN
				Cartboard_disable_request := TRUE;
				State					  := C_LockCartboard;
			END_IF;
			
			IF Crane_EmergencyStop THEN
				State	:= C_StopSequence;
			END_IF;
			
			IF Crane_ImmediateStop THEN
				GD_StatusRequest[8] := TRUE; (* PusherX_EN *)
				OldState		    := State;
				State				:= C_StopSequence; 
			END_IF;
			
			
			
		C_LockCartboard:
			
			IF NOT Cartboard_disable_request THEN
				CraneCartboardCounter	:= CraneCartboardCounter - 1;
				CraneReady				:= TRUE;
				State					:= C_WaitBoxes;
			END_IF;
			
			IF Crane_EmergencyStop THEN
				State	:= C_StopSequence;
			END_IF;
			
			IF Crane_ImmediateStop THEN
				GD_StatusRequest[3] := TRUE; (* CartboardDIS *)
				OldState			:= State;
				State				:= C_StopSequence; 
			END_IF;
			
			
			
		C_WaitBoxes:
			
			IF HoldBoxes THEN
				SlideRail_enable_request := TRUE;
				State					 := C_WaitSlideRailHold;
			END_IF;
			
			IF Crane_EmergencyStop THEN
				State	:= C_StopSequence;
			END_IF;
			
			IF Crane_ImmediateStop OR Crane_OnPhaseStop THEN
				OldState := State;
				State	 := C_StopSequence; 
			END_IF;



		C_WaitSlideRailHold:
			
			IF NOT SlideRail_enable_request THEN
				PusherZ_disable_request	:= TRUE; (* pusher up *)
				State					:= C_WaitPusherZPushUp;
			END_IF;
			
			IF Crane_EmergencyStop THEN
				State	:= C_StopSequence;
			END_IF;
			
			IF Crane_ImmediateStop THEN
				GD_StatusRequest[4] := TRUE; (* SlideRailEN *)
				OldState			:= State;
				State				:= C_StopSequence; 
			END_IF;
		
			
			
		C_WaitPusherZPushUp:
			
			IF NOT PusherZ_disable_request THEN
				PusherX_disable_request	:= TRUE; (* pusher backward *)
				State					:= C_WaitPusherXPushBwd;
			END_IF;
			
			IF Crane_EmergencyStop THEN
				State	:= C_StopSequence;
			END_IF;
			
			IF Crane_ImmediateStop THEN
				GD_StatusRequest[7] := TRUE; (* PusherZ_DIS *)
				OldState			:= State;
				State				:= C_StopSequence; 
			END_IF;
			
			
		
		C_WaitPusherXPushBwd:
			
			IF NOT PusherX_disable_request THEN
				PusherZ_enable_request := TRUE; (* pusher down *)
	  			State				   := C_Idle;
			END_IF;
			
			IF Crane_EmergencyStop THEN
				State	:= C_StopSequence;
			END_IF;
			
			IF Crane_ImmediateStop THEN
				GD_StatusRequest[9] := TRUE; (* PusherX_DIS *)
				OldState			:= State;
				State				:= C_StopSequence;
			END_IF;
		
			
			
		C_Idle:
			
			IF (LoadBoxesOnPallet AND NOT PusherZ_enable_request) THEN
	  			State	:= C_WaitPusherZPushDown;
			END_IF;
			
			IF Crane_EmergencyStop THEN
				State	:= C_StopSequence;
			END_IF;
			
			IF Crane_ImmediateStop THEN
				GD_StatusRequest[6] := TRUE; (* PusherZ_EN *)
				OldState		    := State;
				State				:= C_StopSequence; 
			END_IF;
			
			
			
		C_WaitPusherZPushDown:
			
			IF NOT SecondLayer THEN
				BoxCraneSetPoint := -0.2;
				BoxCrane.Command := CHANGE_POSITION;
				State			 := C_WaitBoxCraneCartboardPos;
			END_IF;
			
			IF SecondLayer THEN
				BoxCraneSetPoint := 0.01;
				BoxCrane.Command := CHANGE_POSITION;
				State			 := C_WaitBoxCraneCartboardPos;
			END_IF;
			
			IF Crane_EmergencyStop THEN
				State	:= C_StopSequence;
			END_IF;
			
			IF Crane_ImmediateStop THEN
				OldState := State;
				State	 := C_StopSequence; 
			END_IF;
		
			
			
		C_WaitBoxCraneCartboardPos:
			
			IF (BoxCranePositionReached OR BoxCranePositionRestored) THEN
				CheckPosition[1]		 := FALSE;
				BoxCranePositionRestored := FALSE;
				BoxCrane.Command		 := IDLE;
				GantryCraneSetPoint		 := -1.11;
				GantryCrane.Command	     := CHANGE_POSITION;
				State					 := C_WaitGantryCraneCartboardPos;
			END_IF;
			
			IF Crane_EmergencyStop THEN
				State	:= C_StopSequence;
			END_IF;
			
			IF Crane_ImmediateStop THEN
				CheckPosition[1] := TRUE;
				
				IF NOT SecondLayer THEN
	  				OldPosition[1] := -0.2;
				END_IF;
				IF SecondLayer THEN
					OldPosition[1] := 0.01;
				END_IF;
				
				OldState := State;
				State	 := C_StopSequence; 
			END_IF;
			
			
		
		C_WaitGantryCraneCartboardPos:
			
			IF (GantryCranePositionReached OR GantryCranePositionRestored) THEN
				CheckPosition[0]			:= FALSE;
				GantryCranePositionRestored	:= FALSE;
				GantryCrane.Command			:= IDLE;
				Vacuum_disable_request		:= TRUE;
				State						:= C_CartboardPosOk;
			END_IF;
			
			IF Crane_EmergencyStop THEN
				State	:= C_StopSequence;
			END_IF;
			
			IF Crane_ImmediateStop THEN
				CheckPosition[0] := TRUE;
				OldPosition[0]	 := -1.11;
				OldState		 := State;
				State			 := C_StopSequence; 
			END_IF;
			
			
		
		C_CartboardPosOk:
			
			IF NOT Vacuum_disable_request THEN
				GantryCraneSetPoint	:= -1.3;
				GantryCrane.Command	:= CHANGE_POSITION;
				State				:= C_BoxesPosOk;
			END_IF;
			
			IF Crane_EmergencyStop THEN
				State	:= C_StopSequence;
			END_IF;
			
			IF Crane_ImmediateStop THEN
				GD_StatusRequest[1] := TRUE; (* Vacuum_DIS *)
				OldState			:= State;
				State				:= C_StopSequence; 
			END_IF;
		
			
			
		C_BoxesPosOk:
			
			IF (GantryCranePositionReached OR GantryCranePositionRestored) THEN
				CheckPosition[0]			:= FALSE;
				GantryCranePositionRestored	:= FALSE;
				GantryCrane.Command			:= IDLE;
				SlideRail_disable_request	:= TRUE;
				State						:= C_OpenSlideRail;
			END_IF;
			
			IF Crane_EmergencyStop THEN
				State	:= C_StopSequence;
			END_IF;
			
			IF Crane_ImmediateStop THEN
				CheckPosition[0] := TRUE;
				OldPosition[0]	 := -1.3;
				OldState		 := State;
				State			 := C_StopSequence; 
			END_IF;
			
			
			
		C_OpenSlideRail:
			
			IF NOT SlideRail_disable_request THEN
				PusherX_enable_request	:= TRUE;
				GantryCraneSetPoint		:= 0;
				GantryCrane.Command		:= CHANGE_POSITION;
				State					:= C_PusherFwd;
			END_IF;
			
			IF Crane_EmergencyStop THEN
				State	:= C_StopSequence;
			END_IF;
			
			IF Crane_ImmediateStop THEN
				GD_StatusRequest[5] := TRUE;  (* SlideRailDIS *)
				OldState			:= State;
				State				:= C_StopSequence; 
			END_IF;
		
			
			
		C_PusherFwd:
			
			IF (NOT PusherX_enable_request AND (GantryCranePositionReached OR GantryCranePositionRestored)) THEN
				CheckPosition[0]			:= FALSE;
				GantryCranePositionRestored	:= FALSE;
				GantryCrane.Command			:= IDLE;
				BoxesOnPallet				:= TRUE;
				State						:= C_WaitStart;
			END_IF;
		
			IF Crane_EmergencyStop THEN
				State	:= C_StopSequence;
			END_IF;
		
			IF Crane_ImmediateStop THEN
				GD_StatusRequest[8] := TRUE; (* PusherX_EN *)
				CheckPosition[0]	:= TRUE;
				OldPosition[0]		:= 0;
				OldState			:= State;
				State				:= C_StopSequence; 
			END_IF;
		
	END_CASE;
	
	
	(*** Generic Devices ***)
	
	Vacuum.DeviceOperation 			:= OperationType;
	Vacuum.DeviceClock 	   			:= TRUE;
	Vacuum.DeviceDiagnosticsEnabled := TRUE;
	Vacuum.DeviceEnablePreset 		:= FALSE;
	Vacuum.DeviceEnabledSensor 		:= Crane_Vacuum;	(* enable feedback *)
	Vacuum.DeviceEnableTime 		:= VacuumEnableTime;
	Vacuum.DeviceDisableTime 		:= VacuumDisableTime;
	Vacuum.DeviceType 				:= DEVICE_WITH_ENABLE_FEEDBACK OR DEVICE_WITH_SINGLE_ACTUATION;
	Vacuum	 ( DeviceEnableRequest  := Vacuum_enable_request,
		       DeviceDisableRequest := Vacuum_disable_request );
	Crane_VacuumGrip	 			:= Vacuum.EnableDevice;	(* single actuation *)
	act_VacuumFault 				:= SIMVacuumFault;
	
	
	Cartboard.DeviceOperation 		   := OperationType;
	Cartboard.DeviceClock 			   := TRUE;
	Cartboard.DeviceDiagnosticsEnabled := TRUE;
	Cartboard.DeviceEnablePreset 	   := FALSE;
	Cartboard.DeviceEnableTime 		   := CartboardEnableTime;
	Cartboard.DeviceDisableTime 	   := CartboardDisableTime;
	Cartboard.DeviceType 			   := DEVICE_WITHOUT_FEEDBACK OR DEVICE_WITH_SINGLE_ACTUATION;
	Cartboard	( DeviceEnableRequest  := Cartboard_enable_request,
				  DeviceDisableRequest := Cartboard_disable_request );
	Crane_CartboardTrig 			   := Cartboard.EnableDevice;	(* single actuation *)
	act_CartboardFault				   := SIMCartboardFault;

	
	SlideRail.DeviceOperation 		   := OperationType;
	SlideRail.DeviceClock 			   := TRUE;
	SlideRail.DeviceDiagnosticsEnabled := TRUE;
	SlideRail.DeviceEnablePreset 	   := FALSE;
	SlideRail.DeviceEnableTime 		   := SlideRailEnableTime;
	SlideRail.DeviceDisableTime 	   := SlideRailDisableTime;
	SlideRail.DeviceType 			   := DEVICE_WITHOUT_FEEDBACK OR DEVICE_WITH_SINGLE_ACTUATION;
	SlideRail	( DeviceEnableRequest  := SlideRail_enable_request,
				  DeviceDisableRequest := SlideRail_disable_request );
	Crane_SlideRail_EN 			   	   := SlideRail.EnableDevice;  (* single actuation *)
	act_SlideRailFault				   := SIMSlideRailFault;
	
	
	PusherZ.DeviceOperation 		 := OperationType;
	PusherZ.DeviceClock 			 := TRUE;
	PusherZ.DeviceDiagnosticsEnabled := TRUE;
	PusherZ.DeviceEnablePreset 		 := FALSE;
	PusherZ.DeviceEnableTime 		 := PusherZEnableTime;
	PusherZ.DeviceDisableTime 		 := PusherZDisableTime;
	PusherZ.DeviceType 				 := DEVICE_WITHOUT_FEEDBACK OR DEVICE_WITH_SINGLE_ACTUATION;
	PusherZ	  ( DeviceEnableRequest  := PusherZ_enable_request,
				DeviceDisableRequest := PusherZ_disable_request );
	Crane_PusherZ_EN 				 := PusherZ.EnableDevice;  (* single actuation *)
	act_PusherZFault				 := SIMPusherZFault;
	
	
	PusherX.DeviceOperation 		 := OperationType;
	PusherX.DeviceClock 			 := TRUE;
	PusherX.DeviceDiagnosticsEnabled := TRUE;
	PusherX.DeviceEnablePreset 		 := FALSE;
	PusherX.DeviceEnableTime 		 := PusherXEnableTime;
	PusherX.DeviceDisableTime 		 := PusherXDisableTime;
	PusherX.DeviceType 				 := DEVICE_WITHOUT_FEEDBACK OR DEVICE_WITH_SINGLE_ACTUATION;
	PusherX    ( DeviceEnableRequest := PusherX_enable_request,
				DeviceDisableRequest := PusherX_disable_request );
	Crane_PusherX_EN 				 := PusherX.EnableDevice;  (* single actuation *)
	act_PusherXFault				 := SIMPusherXFault;

	
	(*** Generic Axes ***)
	
	GantryCrane.NewSetPoint		:= GantryCraneSetPoint;
	GantryCrane.ActualPosition	:= Crane_Gantry_Axis;
	GantryCrane.TGT_SENSOR		:= TRUE;
	Crane_Gantry_Axis_TgtPos	:= GantryCrane.TargetPosition;
	GantryCranePositionReached	:= GantryCrane.InPosition;
	GantryCrane.DeviceTimer		:= 400;
	act_GantryCraneFault		:= SIMGantryCraneFault;
	GantryCrane();
	
	BoxCrane.NewSetPoint	:= BoxCraneSetPoint;
	BoxCrane.ActualPosition	:= Crane_Box_Axis;
	BoxCrane.TGT_SENSOR		:= TRUE;
	Crane_Box_Axis_TgtPos	:=	BoxCrane.TargetPosition;
	BoxCranePositionReached	:= BoxCrane.InPosition;
	BoxCrane.DeviceTimer	:= 400;
	act_BoxCraneFault		:= SIMBoxCraneFault;
	BoxCrane();
	
END_PROGRAM