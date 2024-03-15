
PROGRAM _CYCLIC
		
	CASE State OF
		
		// Recovery of the machine from the Emergency Stop - Every state can be sent here to recover
		
		M_EmergencyStopSequence:
			
			EnableMachine	:= FALSE;
			StartMachine	:= FALSE;
			IF (NOT EmergencyStop AND NOT Feeder_EmergencyStop AND NOT Crane_EmergencyStop AND NOT Pallet_EmergencyStop) THEN
				Feeder_ResetConfig := TRUE;
				Crane_ResetConfig  := TRUE;
				Pallet_ResetConfig := TRUE;
				RestartRequest	   := FALSE;
				State			   := M_WaitStart;
			END_IF;
			
			
			
		// Recovery of the machine from the Immediate Stop (caused by Faults) and the On Phase Stop - Every state can be sent here to recover
			
		M_StopSequence:	
			
			EnableMachine	:= FALSE;
			StartMachine	:= FALSE;
			StopRequest		:= TRUE;
			IF (NOT ImmediateStop AND NOT Feeder_EmergencyStop AND NOT Crane_EmergencyStop AND NOT Pallet_EmergencyStop) 
				AND (NOT OnPhaseStop AND NOT Feeder_OnPhaseStop AND NOT Crane_OnPhaseStop AND NOT Pallet_OnPhaseStop) THEN
				EnableMachine	:= TRUE;
				RestartRequest	:= TRUE;
				State			:= M_WaitStart;
			END_IF;
			
			IF EmergencyStop AND (OnPhaseStopRequest OR ImmediateStopRequest) THEN
				OnPhaseStopRequest		:= FALSE;
				ImmediateStopRequest	:= FALSE;
				Feeder_ImmediateStop	:= FALSE;
				Crane_ImmediateStop		:= FALSE;
				Pallet_ImmediateStop	:= FALSE;
				Feeder_OnPhaseStop		:= FALSE;
				Crane_OnPhaseStop		:= FALSE;
				Pallet_OnPhaseStop		:= FALSE;
				State					:= M_WaitStart;
			END_IF;
			
			IF ImmediateStop AND OnPhaseStopRequest THEN
				OnPhaseStopRequest		:= FALSE;
				Feeder_OnPhaseStop		:= FALSE;
				Crane_OnPhaseStop		:= FALSE;
				Pallet_OnPhaseStop		:= FALSE;
				State					:= M_WaitStart;
					
			END_IF;

			
			
		// Machine restarts when coming from Faults and Stops		
			
		M_Restart:
			
			IF (NOT Feeder_Restart AND NOT Crane_Restart AND NOT Pallet_Restart) THEN
				StopRequest		:= FALSE;
				RestartRequest	:= FALSE;
				StartFeeder		:= TRUE;
				StartCrane		:= TRUE;
				StartPallet 	:= TRUE;
				State			:= OldState;
			END_IF;
			
			
		// Machine starting procedure
			
		M_WaitStart:
			
			// Restart machine after Stops or Faults
			
			IF (StartMachine AND EnableMachine AND RestartRequest) THEN
				Feeder_Restart := TRUE;
				Crane_Restart  := TRUE;
				Pallet_Restart := TRUE;
				State		   := M_Restart;
			END_IF;

			IF (NOT Feeder_ResetConfig AND NOT Crane_ResetConfig AND NOT Pallet_ResetConfig) THEN 
				EnableMachine	:= TRUE;
			END_IF;
			
			// Nominal working condition
			
			IF (StartMachine AND EnableMachine AND NOT RestartRequest) THEN
				StartFeeder   := TRUE;
				StartCrane	  := TRUE;
				StartPallet   := TRUE;
				State		  := M_BoxPosOk;
			END_IF;
			
			IF EmergencyStop THEN
				Feeder_EmergencyStop := TRUE;
				Crane_EmergencyStop  := TRUE;
				Pallet_EmergencyStop := TRUE;
				State				 := M_EmergencyStopSequence;
			END_IF;
			
			IF ImmediateStop THEN
				ImmediateStopRequest := TRUE;
				
				IF NOT StopRequest THEN
					OldState := State;
				END_IF;
				
				Feeder_ImmediateStop := TRUE;
				Crane_ImmediateStop  := TRUE;
				Pallet_ImmediateStop := TRUE;
				State				 := M_StopSequence;
			END_IF;
						
			IF OnPhaseStop AND NOT StopRequest THEN
				OnPhaseStopRequest	:= TRUE;
				
				IF NOT StopRequest THEN
					OldState	:= State;
				END_IF;
				
				Feeder_OnPhaseStop := TRUE;
				Crane_OnPhaseStop  := TRUE;
				Pallet_OnPhaseStop := TRUE;
				State			   := M_StopSequence;
			END_IF;
	
		
		
		// A layer of boxes is ready to be placed on the BoxCrane
			
		M_BoxPosOk:
			
			PalletExit_DONE	:= FALSE;
			BoxesOnPallet	:= FALSE;
			
			IF (FeederReady AND CraneReady) THEN
				LoadBoxesOnCrane := TRUE;
				State			  := M_BoxOnCrane;
			END_IF;
		
			IF EmergencyStop THEN
				Feeder_EmergencyStop := TRUE;
				Crane_EmergencyStop  := TRUE;
				Pallet_EmergencyStop := TRUE;
				State				 := M_EmergencyStopSequence;
			END_IF;
			
			IF ImmediateStop THEN
				ImmediateStopRequest := TRUE;
				OldState			 := State;
				Feeder_ImmediateStop := TRUE;
				Crane_ImmediateStop  := TRUE;
				Pallet_ImmediateStop := TRUE;
				State				 := M_StopSequence;
			END_IF;
			
			IF OnPhaseStop THEN
				OnPhaseStopRequest := TRUE;
				OldState		   := State;				
				Feeder_OnPhaseStop := TRUE;
				Crane_OnPhaseStop  := TRUE;
				Pallet_OnPhaseStop := TRUE;
				State			   := M_StopSequence;
			END_IF;
			
		
		
		// 	The layer of boxes is placed on the BoxCrane
			
		M_BoxOnCrane:
			
			IF BoxesOnCrane THEN
				FeederReady			:= FALSE;
				CraneReady			:= FALSE;
				LoadBoxesOnCrane	:= FALSE;
				HoldBoxes			:= TRUE;
				State				:= M_WaitForPallet;
			END_IF;
			
			IF EmergencyStop THEN
				Feeder_EmergencyStop := TRUE;
				Crane_EmergencyStop  := TRUE;
				Pallet_EmergencyStop := TRUE;
				State				 := M_EmergencyStopSequence;
			END_IF;
			
			IF ImmediateStop THEN
				ImmediateStopRequest := TRUE;
				OldState			 := State;
				Feeder_ImmediateStop := TRUE;
				Crane_ImmediateStop  := TRUE;
				Pallet_ImmediateStop := TRUE;
				State				 := M_StopSequence;
			END_IF;
			
			IF OnPhaseStop THEN
				OnPhaseStopRequest := TRUE;
				OldState		   := State;				
				Feeder_OnPhaseStop := TRUE;
				Crane_OnPhaseStop  := TRUE;
				Pallet_OnPhaseStop := TRUE;
				State			   := M_StopSequence;
			END_IF;
			
		
			
		// Pallet is reaching the correct position in order to load the boxes and the cartboard on it 	

		M_WaitForPallet:
			
			IF PalletReady THEN
				BoxesOnCrane	  := FALSE;
				LoadBoxesOnPallet := TRUE;
				State			  := M_BoxOnPallet;
			END_IF;
			
			IF EmergencyStop THEN
				Feeder_EmergencyStop := TRUE;
				Crane_EmergencyStop  := TRUE;
				Pallet_EmergencyStop := TRUE;
				State				 := M_EmergencyStopSequence;
			END_IF;
			
			IF ImmediateStop THEN
				ImmediateStopRequest := TRUE;
				OldState			 := State;
				Feeder_ImmediateStop := TRUE;
				Crane_ImmediateStop  := TRUE;
				Pallet_ImmediateStop := TRUE;
				State				 := M_StopSequence;
			END_IF;
			
			IF OnPhaseStop THEN
				OnPhaseStopRequest := TRUE;
				OldState		   := State;				
				Feeder_OnPhaseStop := TRUE;
				Crane_OnPhaseStop  := TRUE;
				Pallet_OnPhaseStop := TRUE;
				State			   := M_StopSequence;
			END_IF;
					
		
			
		// Both layers of boxer and  both cartboards are placed on the pallet	
			
		M_BoxOnPallet:
			
			IF BoxesOnPallet THEN
				HoldBoxes		  := FALSE;
				LoadBoxesOnPallet := FALSE;
				
				IF SecondLayer THEN
					PalletExit_EN	:= TRUE;
					State			:= M_PalletExit;
				END_IF;
				
				IF NOT SecondLayer THEN
					State := M_WaitStart;
				END_IF;
			END_IF;
			
			IF EmergencyStop THEN
				Feeder_EmergencyStop := TRUE;
				Crane_EmergencyStop  := TRUE;
				Pallet_EmergencyStop := TRUE;
				State				 := M_EmergencyStopSequence;
			END_IF;
			
			IF ImmediateStop THEN
				ImmediateStopRequest := TRUE;
				OldState			 := State;
				Feeder_ImmediateStop := TRUE;
				Crane_ImmediateStop  := TRUE;
				Pallet_ImmediateStop := TRUE;
				State				 := M_StopSequence;
			END_IF;
			
			IF OnPhaseStop THEN
				OnPhaseStopRequest := TRUE;
				OldState		   := State;				
				Feeder_OnPhaseStop := TRUE;
				Crane_OnPhaseStop  := TRUE;
				Pallet_OnPhaseStop := TRUE;
				State			   := M_StopSequence;
			END_IF;
			
		
			
		// Pallet is ready to leave the station	
			
		M_PalletExit:
			
			IF PalletExit_DONE THEN
				PalletReady	    := FALSE;
				PalletExit_EN	:= FALSE;
				SecondLayer		:= FALSE;
				PalletOutput 	:= PalletOutput + 1;
				State			:= M_WaitStart;
			END_IF;
		
			IF EmergencyStop THEN
				Feeder_EmergencyStop := TRUE;
				Crane_EmergencyStop  := TRUE;
				Pallet_EmergencyStop := TRUE;
				State				 := M_EmergencyStopSequence;
			END_IF;
			
			IF ImmediateStop THEN
				ImmediateStopRequest := TRUE;
				OldState			 := State;
				Feeder_ImmediateStop := TRUE;
				Crane_ImmediateStop  := TRUE;
				Pallet_ImmediateStop := TRUE;
				State				 := M_StopSequence;
			END_IF;
			
			IF OnPhaseStop THEN
				OnPhaseStopRequest := TRUE;
				OldState		   := State;				
				Feeder_OnPhaseStop := TRUE;
				Crane_OnPhaseStop  := TRUE;
				Pallet_OnPhaseStop := TRUE;
				State			   := M_StopSequence;
			END_IF;
		
	END_CASE;

END_PROGRAM