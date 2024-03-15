
PROGRAM _CYCLIC

	
	IF (OperationType = Init) THEN
		SignalManagement (OperationType := Init);
		SignalManagement (OperationType := StartConfiguration); 
		SignalManagement.OperationType  := Configuration;
		OperationType 					:= Run;
	ELSE
		SignalManagement (OperationType := StartGeneration); 
		SignalManagement.OperationType  := Generation;
	END_IF;
	
	
	SignalManagement
	(SignalType  	 := Alarm,
	SignalCode   	 := mOnPhaseStopRequested,
	SignalOutput 	 := OnPhaseStopSIG,
	ActivationSignal := OnPhaseStopButton,
	);
	
	
	SignalManagement
	(SignalType 	 := Alarm OR AuxReset,
	SignalCode 		 := mEmergencyStopRequested,
	SignalOutput 	 := EmergencyStopSIG,
	ActivationSignal := EmergencyStopButton,
	);
	
	
	(*** FEEDER GROUP FAULTS	***)
	
	(* Conveyor if fault *)
	SignalManagement
	(SignalType 	 := Alarm OR AuxReset,
	SignalCode		 := mConveyorIfFault,
	SignalOutput 	 := ImmediateStopSIG,
	ActivationSignal := act_ConveyorIFFault,
	);
	
	(* Pusher fault *)
	SignalManagement
	(SignalType 	 := Alarm OR AuxReset,
	SignalCode 		 := mFeederPusherFault,
	SignalOutput 	 := ImmediateStopSIG,
	ActivationSignal := act_FeederPusherFault,
	);
	
	(* conveyor turn 1 fault *)
	SignalManagement
	(SignalType 	 := Alarm OR AuxReset,
	SignalCode 		 := mConveyorTurn1Fault,
	SignalOutput 	 := ImmediateStopSIG,
	ActivationSignal := act_ConveyorTurn1Fault,
	);
	
	(* Turnpusher fault *)
	SignalManagement
	(SignalType 	 := Alarm OR AuxReset,
	SignalCode 		 := mTurnpusherFault,
	SignalOutput 	 := ImmediateStopSIG,
	ActivationSignal := act_TurnpusherFault,
	);

	(* conveyor end fault *)
	SignalManagement
	(SignalType 	 := Alarm OR AuxReset,
	SignalCode 	 	 := mConveyorEndFault,
	SignalOutput 	 := ImmediateStopSIG,
	ActivationSignal := act_ConveyorEndFault,
	);
	
	(* Carriage fault *)
	SignalManagement
	(SignalType 	 := Alarm OR AuxReset,
	SignalCode 		 := mCarriageFault,
	SignalOutput 	 := ImmediateStopSIG,
	ActivationSignal := act_CarriageFault,
	);
	
	
	(*** CRANE GROUP FAULTS ***)
	
	(* Box crane fault *)
	SignalManagement
	(SignalType 	 := Alarm OR AuxReset,
	SignalCode 		 := mBoxCraneFault,
	SignalOutput 	 := ImmediateStopSIG,
	ActivationSignal := act_BoxCraneFault,
	);
	
	(* Gantry crane fault *)
	SignalManagement
	(SignalType 	 := Alarm OR AuxReset,
	SignalCode 	 	 := mGantryCraneFault,
	SignalOutput 	 := ImmediateStopSIG,
	ActivationSignal := act_GantryCraneFault,
	);
	
	(* vacuum fault *)
	SignalManagement
	(SignalType 	 := Alarm OR AuxReset,
	SignalCode 		 := mVacuumFault,
	SignalOutput 	 := ImmediateStopSIG,
	ActivationSignal := act_VacuumFault,
	);
	
	(* cartboard fault *)
	SignalManagement
	(SignalType 	 := Alarm OR AuxReset,
	SignalCode 		 := mCartboardFault,
	SignalOutput 	 := ImmediateStopSIG,
	ActivationSignal := act_CartboardFault
	);
	
	(* Pusher X fault *)
	SignalManagement
	(SignalType		 := Alarm OR AuxReset,
	SignalCode 		 := mCranePusherxfault,
	SignalOutput 	 := ImmediateStopSIG,
	ActivationSignal := act_PusherXFault,
	);
	
	(* Pusher Z fault *)
	SignalManagement
	(SignalType 	 := Alarm OR AuxReset,
	SignalCode 		 := mCranePusherzfault,
	SignalOutput 	 := ImmediateStopSIG,
	ActivationSignal := act_PusherZFault,
	);
	
	(* Slide Rail fault *)
	SignalManagement
	(SignalType 	 := Alarm OR AuxReset,
	SignalCode 	     := mSlideRailFault,
	SignalOutput 	 := ImmediateStopSIG,
	ActivationSignal := act_SlideRailFault,
	);
	
	
	(*** PALLET GROUP FAULTS ***)
	
	(* Lifter fault *)
	SignalManagement
	(SignalType 	 := Alarm OR AuxReset,
	SignalCode 		 := mPalletLifterFault,
	SignalOutput 	 := ImmediateStopSIG,
	ActivationSignal := act_PalletLifterFault,
	);
	
	(* fork fault *)
	SignalManagement
	(SignalType 	 := Alarm OR AuxReset,
	SignalCode 		 := mPalletforkFault,
	SignalOutput 	 := ImmediateStopSIG,
	ActivationSignal := act_PalletForkFault,
	);
	
	(* conveyor 1 fault *)
	SignalManagement
	(SignalType 	 := Alarm OR AuxReset,
	SignalCode 	 	 := mPalletConveyor1Fault,
	SignalOutput 	 := ImmediateStopSIG,
	ActivationSignal := act_PalletConveyor1Fault,
	);
	
	(* conveyor 2 fault *)
	SignalManagement
	(SignalType 	 := Alarm OR AuxReset,
	SignalCode 		 := mPalletConveyor2Fault,
	SignalOutput 	 := ImmediateStopSIG,
	ActivationSignal := act_PalletConveyor2Fault,
	);
	
	(* PALLET ALMOST OVER Warning *)
	SignalManagement
	(SignalType 	 := Warning,
	SignalCode 		 := mPalletsAlmostOver,
		//	SignalOutput 	 := PalletAlmostOver,
	SignalOutput 	 := MaterialsRunOut,
	ActivationSignal := (PalletCounter = 1),
	);
	
	(* PALLET OVER Alarm *)
	SignalManagement
	(SignalType 	 := Alarm,
	SignalCode 		 := mPalletsOver,
	SignalOutput 	 := OnPhaseStopSIG,
	ActivationSignal := (PalletCounter = 0),
	);
	
	(* CARTBOARD ALMOST OVER Warning *)
	SignalManagement
	(SignalType 	 := Warning,
	SignalCode 		 := mCartboardAlmostOver,
		//	SignalOutput	 := CartboardAlmostOver,
	SignalOutput 	 := MaterialsRunOut,
	ActivationSignal := (CraneCartboardCounter = 1),
	);
	
	(* CARTBOARD OVER Alarm *)
	SignalManagement
	(SignalType 	 := Alarm,
	SignalCode 		 := mCartboardOver,
	SignalOutput 	 := OnPhaseStopSIG,
	ActivationSignal := (CraneCartboardCounter = 0),
	);
	
	OutputSignals := SignalManagement.SignalOutputs;
	
	IF (OperationType = RUN) THEN
		SignalManagement (OperationType := RUN); (* outputs selection *)
	END_IF;

	EmergencyStop := ((OutputSignals AND EmergencyStopSIG) = EmergencyStopSIG);
	
	IF EmergencyStop THEN
		ImmediateStop := FALSE;
		OnPhaseStop	  := FALSE;
	END_IF;
	
	IF NOT EmergencyStop THEN
		ImmediateStop := ((OutputSignals AND ImmediateStopSIG) = ImmediateStopSIG);
		OnPhaseStop	  := FALSE;
		IF NOT ImmediateStop THEN
			OnPhaseStop := ((OutputSignals AND OnPhaseStopSIG) = OnPhaseStopSIG);
		END_IF;
	END_IF;
		
	//	OutOfPallet 		:= ((OutputSignals AND PalletAlmostOver) = PalletAlmostOver);
	//	OutOfCartboard		:= ((OutputSignals AND CartboardAlmostOver) = CartboardAlmostOver);
	
	OnePalletLeft	 	:= (PalletCounter = 1);
	OneCartboardLeft 	:= (CraneCartboardCounter = 1);
	PalletOver	 		:= (PalletCounter = 0);
	CartboardOver 		:= (CraneCartboardCounter = 0);
	
	IF NOT EmergencyStop AND NOT ImmediateStop AND NOT OnPhaseStop THEN
		OutOfMaterial := ((OutputSignals AND MaterialsRunOut) = MaterialsRunOut);
	ELSE
		OutOfMaterial := FALSE;
	END_IF;
	
END_PROGRAM