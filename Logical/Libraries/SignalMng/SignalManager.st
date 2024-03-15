
FUNCTION_BLOCK SignalManager

	CASE OperationType OF
		
(* 0 *)	START_CONFIGURATION: (* Reset signals counts *)
			
			NumberOfAlarms 	    := 0;
			NumberOfAnomalies   := 0;
			NumberOfWarnings 	:= 0;
			NumberOfInformation := 0;
			
			
(* 1 *)	CONFIGURATION: (* counting signals *)
			
			CASE (SignalType AND SIGNAL_TYPE_MASK) OF
				ALARM:
					NumberOfAlarms 	    := NumberOfAlarms + 1;	
					
				ANOMALY:
					NumberOfAnomalies   := NumberOfAnomalies + 1;
					
				WARNING:
					NumberOfWarnings    := NumberOfWarnings + 1;
					
				INFORMATION:
					NumberOfInformation := NumberOfInformation + 1;
			END_CASE
			
			
(* 2 *)	START_GENERATION: 
			
			AuxResetEnable	   := FALSE;
			ResetEnable 	   := FALSE;
			SignalOutputs 	   := NONE;
			ResetActivation    := Reset AND NOT ResetOld;
			ResetOld 		   := Reset;
			AuxResetActivation := KeyReset AND NOT KeyResetOld;
			KeyResetOld		   := KeyReset;
		
			
(* 3 *)	GENERATION:
			
			CASE (SignalType AND SIGNAL_TYPE_MASK) OF
				ALARM:
					Index 	  := NumberOfActiveAlarms;
					BaseIndex := 0;
					Condition := TRUE;
					
				ANOMALY:
					Index 	  := NumberOfActiveAnomalies;
					BaseIndex := NumberOfAlarms;
					Condition := TRUE;
					
				WARNING:
					Index 	  := NumberOfActiveWarning;
					BaseIndex := NumberOfAlarms + NumberOfAnomalies;
					Condition := FALSE;
					
				INFORMATION:
					Index 	  := NumberOfActiveInformation;
					BaseIndex := NumberOfAlarms + NumberOfAnomalies + NumberOfWarnings;
					Condition := FALSE;
			END_CASE
			
			IF ActivationSignal AND NOT Signals[SignalCode] THEN
				Signals[SignalCode] 				 := TRUE;
				Index 								 := Index + 1;
				ActiveSignalCodes[BaseIndex + Index] := SignalCode;
			END_IF
			
			AuxResetRequired := ((SignalType AND AUX_RESET) = AUX_RESET);
			
			IF (Condition AND Signals[SignalCode] AND NOT ActivationSignal AND (ActiveSignalCodes[BaseIndex + 1] = SignalCode) AND AuxResetRequired) THEN
				AuxResetEnable := TRUE;
			END_IF
			
			IF (Condition AND Signals[SignalCode] AND NOT ActivationSignal AND (ActiveSignalCodes[BaseIndex + 1] = SignalCode) AND NOT AuxResetRequired) THEN
				ResetEnable := TRUE;
//				AuxResetEnable := TRUE;
			END_IF
			
			IF ((ResetActivation OR NOT Condition) AND Signals[SignalCode] AND NOT ActivationSignal AND (ActiveSignalCodes[BaseIndex + 1] = SignalCode) AND NOT AuxResetRequired) THEN
				Signals[SignalCode] := FALSE;
				
				FOR i := 2 TO Index DO
					ActiveSignalCodes[BaseIndex + i-1] := ActiveSignalCodes[BaseIndex + i];
				END_FOR;
				
				ActiveSignalCodes[BaseIndex + Index] := 0;
				Index 								 := Index - 1;
				ResetActivation 					 := FALSE;
			END_IF
			
			IF ((AuxResetActivation OR NOT Condition) AND Signals[SignalCode] AND NOT ActivationSignal AND (ActiveSignalCodes[BaseIndex + 1] = SignalCode) (*AND AuxResetRequired*)) THEN
				Signals[SignalCode] := FALSE;
				
				FOR i := 2 TO Index DO
					ActiveSignalCodes[BaseIndex + i-1] := ActiveSignalCodes[BaseIndex + i];
				END_FOR;
				
				ActiveSignalCodes[BaseIndex + Index] := 0;
				Index 								 := Index - 1;				
				AuxResetActivation 					 := FALSE; 
			END_IF
						
			CASE (SignalType AND SIGNAL_TYPE_MASK) OF
				ALARM:
					NumberOfActiveAlarms := Index;
					
				ANOMALY:
					NumberOfActiveAnomalies := Index;
					
				WARNING:
					NumberOfActiveWarning := Index;
					
				INFORMATION:
					NumberOfActiveInformation := Index;
			END_CASE
			
			IF Signals[SignalCode] THEN
				SignalOutputs := SignalOutputs OR SignalOutput;
			END_IF
			
			
(* 4 *)	RUN:
			
			FirstActiveSignalIndex	:= ActiveSignalCodes[1];
			SecondActiveSignalIndex	:= ActiveSignalCodes[2];
			ThirdActiveSignalIndex	:= ActiveSignalCodes[3];
			FourthActiveSignalIndex	:= ActiveSignalCodes[4];
			FifthActiveSignalIndex  := ActiveSignalCodes[5];

			LastInformationIndex 	:= NumberOfAlarms + NumberOfAnomalies + NumberOfWarnings + NumberOfActiveInformation;
			
			IF NumberOfActiveInformation > 0 THEN
				SignalTypeInformation	:= TRUE;
			ELSE
				SignalTypeInformation	:= FALSE;
			END_IF
			
			LastAnomalyIndex := NumberOfAlarms + NumberOfAnomalies + NumberOfActiveAnomalies;
			
			IF NumberOfActiveAnomalies > 0 THEN
				SignalTypeAnomaly	:= TRUE;
			ELSE
				SignalTypeAnomaly	:= FALSE;
			END_IF
			
			LastWarningIndex := NumberOfAlarms + NumberOfActiveWarning;
			
			IF NumberOfActiveWarning > 0 THEN
				SignalTypeWarning	:= TRUE;
			ELSE
				SignalTypeWarning	:= FALSE;
			END_IF
			
			IF NumberOfActiveAlarms = 2 AND ResetEnable AND AuxResetEnable THEN
				NumberOfActiveAlarms := 1;
			END_IF	
				
			IF NumberOfActiveAlarms > 0 THEN
				SignalTypeAlarm	:= TRUE;
			ELSE
				SignalTypeAlarm	:= FALSE;
			END_IF			
		
	END_CASE

	
// Output of the alarm registry log
	
	
//	First alarm
	IF 	FirstActiveSignalIndex = 1	THEN
		Firstslot:= 'Turnpusher BROKEN';
	ELSIF FirstActiveSignalIndex = 2 THEN
		Firstslot:= 'Pusher BROKEN';
	ELSIF FirstActiveSignalIndex = 3 THEN
		Firstslot:= 'Crane Pusher X-axis BROKEN';
	ELSIF FirstActiveSignalIndex = 4 THEN
		Firstslot:= 'Crane Pusher Z-axis BROKEN';
	ELSIF FirstActiveSignalIndex = 5 THEN
		Firstslot:= 'Vacuum BROKEN';
	ELSIF FirstActiveSignalIndex = 6 THEN
		Firstslot:= 'Pallet Fork BROKEN';
	ELSIF FirstActiveSignalIndex = 7 THEN
		Firstslot:= 'Pallets OVER';
	ELSIF FirstActiveSignalIndex = 8 THEN
		Firstslot:= 'Carriage BROKEN';
	ELSIF FirstActiveSignalIndex = 9 THEN
		Firstslot:= 'Gantry Crane BROKEN';
	ELSIF FirstActiveSignalIndex = 10 THEN
		Firstslot:= 'Box Crane BROKEN';
	ELSIF FirstActiveSignalIndex = 11 THEN
		Firstslot:= 'Pallet Lifter BROKEN';
	ELSIF FirstActiveSignalIndex = 12 THEN
			Firstslot:= 'Pallets ALMOST OVER';
	ELSIF FirstActiveSignalIndex = 13 THEN	
		Firstslot:= 'On Phase Stop REQUESTED';
	ELSIF FirstActiveSignalIndex = 14 THEN
		Firstslot:= 'Emergency Stop REQUESTED';	
	ELSIF FirstActiveSignalIndex = 15 THEN
		Firstslot:= 'Cartboards ALMOST OVER';
	ELSIF FirstActiveSignalIndex = 16 THEN
		Firstslot:= 'Cartboards OVER';		
	ELSIF FirstActiveSignalIndex = 17 THEN
		Firstslot:= 'Conveyor 1 BROKEN';		
	ELSIF FirstActiveSignalIndex = 18 THEN
		Firstslot:= 'Conveyor 2 BROKEN';	
	ELSIF FirstActiveSignalIndex = 19 THEN
		Firstslot:= 'Conveyor 3 BROKEN';	
//	ELSIF FirstActiveSignalIndex = 20 THEN
//		Firstslot:= 'Cartboards FAULT';		
	ELSIF FirstActiveSignalIndex = 21 THEN
		Firstslot:= 'Slide Rail BROKEN';		
	ELSIF FirstActiveSignalIndex = 22 THEN
		Firstslot:= 'Pallet Conveyor 1 BROKEN';	
	ELSIF FirstActiveSignalIndex = 23 THEN
		Firstslot:= 'Pallet Conveyor 2 BROKEN';
	ELSE
		Firstslot:= '-';																							
	END_IF;	

	
//	Second alarm
	IF 	SecondActiveSignalIndex = 1	THEN
		Secondslot := 'Turnpusher BROKEN';
	ELSIF SecondActiveSignalIndex = 2 THEN
		Secondslot:= 'Pusher BROKEN';
	ELSIF SecondActiveSignalIndex = 3 THEN
		Secondslot:= 'Crane Pusher X-axis BROKEN';
	ELSIF SecondActiveSignalIndex = 4 THEN
		Secondslot:= 'Crane Pusher Z-axis BROKEN';
	ELSIF SecondActiveSignalIndex = 5 THEN
		Secondslot:= 'Vacuum BROKEN';
	ELSIF SecondActiveSignalIndex = 6 THEN
		Secondslot:= 'Pallet Fork BROKEN';
	ELSIF SecondActiveSignalIndex = 7 THEN
		Secondslot:= 'Pallets OVER';
	ELSIF SecondActiveSignalIndex = 8 THEN
		Secondslot:= 'Carriage BROKEN';
	ELSIF SecondActiveSignalIndex = 9 THEN	
		Secondslot:= 'Gantry Crane BROKEN';
	ELSIF SecondActiveSignalIndex = 10 THEN
		Secondslot:= 'Box Crane BROKEN';
	ELSIF SecondActiveSignalIndex = 11 THEN
		Secondslot:= 'Pallet Lifter BROKEN';
	ELSIF SecondActiveSignalIndex = 12 THEN
		Secondslot:= 'Pallets ALMOST OVER';
	ELSIF SecondActiveSignalIndex = 13 THEN	
		Secondslot:= 'On Phase Stop REQUESTED';
	ELSIF SecondActiveSignalIndex = 14 THEN
		Secondslot:= 'Emergency Stop REQUESTED';	
	ELSIF SecondActiveSignalIndex = 15 THEN
 		Secondslot:= 'Cartboards ALMOST OVER';
	ELSIF SecondActiveSignalIndex = 16 THEN
		Secondslot:= 'Cartboards OVER';	
	ELSIF SecondActiveSignalIndex = 17 THEN
		Secondslot:= 'Conveyor 1 BROKEN';		
	ELSIF SecondActiveSignalIndex = 18 THEN
		Secondslot:= 'Conveyor 2 BROKEN';
	ELSIF SecondActiveSignalIndex = 19 THEN
		Secondslot:= 'Conveyor 3 BROKEN';
//	ELSIF SecondActiveSignalIndex = 20 THEN
//		Secondslot:= 'Cartboard FAULT';		
	ELSIF SecondActiveSignalIndex = 21 THEN
		Secondslot:= 'Slide Rail BROKEN';		
	ELSIF SecondActiveSignalIndex = 22 THEN
		Secondslot:= 'Pallet Conveyor 1 BROKEN';	
	ELSIF SecondActiveSignalIndex = 23 THEN
		Secondslot:= 'Pallet Conveyor 2 BROKEN';
	ELSE
		Secondslot:= '-';																							
	END_IF;	

	
// 	Third alarm
	IF 	ThirdActiveSignalIndex = 1	THEN
		Thirdslot:= 'Turnpusher BROKEN';
	ELSIF ThirdActiveSignalIndex = 2 THEN
		Thirdslot:= 'Pusher BROKEN';
	ELSIF ThirdActiveSignalIndex = 3 THEN
		Thirdslot:= 'Crane Pusher X-axis BROKEN';
	ELSIF ThirdActiveSignalIndex = 4 THEN
		Thirdslot:= 'Crane Pusher Z-axis BROKEN';
	ELSIF ThirdActiveSignalIndex = 5 THEN
		Thirdslot:= 'Vacuum BROKEN';
	ELSIF ThirdActiveSignalIndex = 6 THEN
		Thirdslot:= 'Pallet Fork BROKEN';
	ELSIF ThirdActiveSignalIndex = 7 THEN
		Thirdslot:= 'Pallets OVER';
	ELSIF ThirdActiveSignalIndex = 8 THEN
		Thirdslot:= 'Carriage BROKEN';
	ELSIF ThirdActiveSignalIndex = 9 THEN	
		Thirdslot:= 'Gantry Crane BROKEN';
	ELSIF ThirdActiveSignalIndex = 10 THEN
		Thirdslot:= 'Box Crane BROKEN';
	ELSIF ThirdActiveSignalIndex = 11 THEN	
		Thirdslot:= 'Pallet Lifter BROKEN';
	ELSIF ThirdActiveSignalIndex = 12 THEN	
		Thirdslot:= 'Pallets ALMOST OVER';
	ELSIF ThirdActiveSignalIndex = 13 THEN	
		Thirdslot:= 'On Phase Stop REQUESTED';
	ELSIF ThirdActiveSignalIndex = 14 THEN
		Thirdslot:= 'Emergency Stop REQUESTED';
	ELSIF ThirdActiveSignalIndex = 15 THEN
		Thirdslot:= 'Cartboards ALMOST OVER';
	ELSIF ThirdActiveSignalIndex = 16 THEN
		Thirdslot:= 'Cartboards OVER';
	ELSIF ThirdActiveSignalIndex = 17 THEN		
		Thirdslot:= 'Conveyor 1 BROKEN';	
	ELSIF ThirdActiveSignalIndex = 18 THEN	
		Thirdslot:= 'Conveyor 2 BROKEN';
	ELSIF ThirdActiveSignalIndex = 19 THEN
		Thirdslot:= 'Conveyor 3 BROKEN';
//	ELSIF ThirdActiveSignalIndex = 20 THEN
//		Thirdslot:= 'Cartboards FAULT';			
	ELSIF ThirdActiveSignalIndex = 21 THEN
		Thirdslot:= 'Slide Rail BROKEN';	
	ELSIF ThirdActiveSignalIndex = 22 THEN
		Thirdslot:= 'Pallet Conveyor 1 BROKEN';	
	ELSIF ThirdActiveSignalIndex = 23 THEN
		Thirdslot:= 'Pallet Conveyor 2 BROKEN';
	ELSE
		Thirdslot:= '-';						
	END_IF				

	
//	Fourth alarm
	IF 	FourthActiveSignalIndex = 1	THEN
		Fourthslot:= 'Turnpusher BROKEN';
	ELSIF FourthActiveSignalIndex = 2 THEN
		Fourthslot:= 'Pusher BROKEN';
	ELSIF FourthActiveSignalIndex = 3 THEN
		Fourthslot:= 'Crane Pusher X-axis BROKEN';
	ELSIF FourthActiveSignalIndex = 4 THEN
		Fourthslot:= 'Crane Pusher Z-axis BROKEN';
	ELSIF FourthActiveSignalIndex = 5 THEN
		Fourthslot:= 'Vacuum BROKEN';
	ELSIF FourthActiveSignalIndex = 6 THEN
		Fourthslot:= 'Pallet Fork BROKEN';
	ELSIF FourthActiveSignalIndex = 7 THEN
		Fourthslot:= 'Pallets OVER';
	ELSIF FourthActiveSignalIndex = 8 THEN
		Fourthslot:= 'Carriage BROKEN';
	ELSIF FourthActiveSignalIndex = 9 THEN	
		Fourthslot:= 'Gantry Crane BROKEN';
	ELSIF FourthActiveSignalIndex = 10 THEN
		Fourthslot:= 'Box Crane BROKEN';
	ELSIF FourthActiveSignalIndex = 11 THEN	
		Fourthslot:= 'Pallet Lifter BROKEN';
	ELSIF FourthActiveSignalIndex = 12 THEN	
		Fourthslot:= 'Pallets ALMOST OVER';
	ELSIF FourthActiveSignalIndex = 13 THEN	
		Fourthslot:= 'On Phase Stop REQUESTED';
	ELSIF FourthActiveSignalIndex = 14 THEN
		Fourthslot:= 'Emergency Stop REQUESTED';
	ELSIF FourthActiveSignalIndex = 15 THEN
		Fourthslot:= 'Cartboards ALMOST OVER';
	ELSIF FourthActiveSignalIndex = 16 THEN
		Fourthslot:= 'Cartboards OVER';
	ELSIF FourthActiveSignalIndex = 17 THEN		
		Fourthslot:= 'Conveyor 1 BROKEN';
	ELSIF FourthActiveSignalIndex = 18 THEN	
		Fourthslot:= 'Conveyor 2 BROKEN';
	ELSIF FourthActiveSignalIndex = 19 THEN
		Fourthslot:= 'Conveyor 3 BROKEN';
//	ELSIF FourthActiveSignalIndex = 20 THEN
//		Fourthslot:= 'Cartboards FAULT';			
	ELSIF FourthActiveSignalIndex = 21 THEN
		Fourthslot:= 'Slide Rail BROKEN';	
	ELSIF FourthActiveSignalIndex = 22 THEN
		Fourthslot:= 'Pallet Conveyor 1 BROKEN';	
	ELSIF FourthActiveSignalIndex = 23 THEN
		Fourthslot:= 'Pallet Conveyor 2 BROKEN';
	ELSE
		Fourthslot:= '-';						
	END_IF

	
	//	Fifth alarm
	IF 	FifthActiveSignalIndex = 1	THEN
		Fifthslot:= 'Turnpusher BROKEN'; 
	ELSIF FifthActiveSignalIndex = 2 THEN
		Fifthslot:= 'Pusher BROKEN';
	ELSIF FifthActiveSignalIndex = 3 THEN
		Fifthslot:= 'Crane Pusher X-axis BROKEN';
	ELSIF FifthActiveSignalIndex = 4 THEN
		Fifthslot:= 'Crane Pusher Z-axis BROKEN';
	ELSIF FifthActiveSignalIndex = 5 THEN
		Fifthslot:= 'Vacuum BROKEN';
	ELSIF FifthActiveSignalIndex = 6 THEN
		Fifthslot:= 'Pallet Fork BROKEN';
	ELSIF FifthActiveSignalIndex = 7 THEN
		Fifthslot:= 'Pallets OVER';
	ELSIF FifthActiveSignalIndex = 8 THEN
		Fifthslot:= 'Carriage BROKEN';
	ELSIF FifthActiveSignalIndex = 9 THEN	
		Fifthslot:= 'Gantry Crane BROKEN';
	ELSIF FifthActiveSignalIndex = 10 THEN
		Fifthslot:= 'Box Crane BROKEN';
	ELSIF FifthActiveSignalIndex = 11 THEN	
		Fifthslot:= 'Pallet Lifter BROKEN';
	ELSIF FifthActiveSignalIndex = 12 THEN	
		Fifthslot:= 'Pallets ALMOST OVER';
	ELSIF FifthActiveSignalIndex = 13 THEN	
		Fifthslot:= 'On Phase Stop REQUESTED';
	ELSIF FifthActiveSignalIndex = 14 THEN
		Fifthslot:= 'Emergency Stop REQUESTED';
	ELSIF FifthActiveSignalIndex = 15 THEN
		Fifthslot:= 'Cartboards ALMOST OVER';
	ELSIF FifthActiveSignalIndex = 16 THEN
		Fifthslot:= 'Cartboards OVER';
	ELSIF FifthActiveSignalIndex = 17 THEN		
		Fifthslot:= 'Conveyor 1 BROKEN';
	ELSIF FifthActiveSignalIndex = 18 THEN	
		Fifthslot:= 'Conveyor 2 BROKEN';
	ELSIF FifthActiveSignalIndex = 19 THEN
		Fifthslot:= 'Conveyor 3 BROKEN';
//	ELSIF FifthActiveSignalIndex = 20 THEN
//		Fifthslot:= 'Cartboards FAULT';			
	ELSIF FifthActiveSignalIndex = 21 THEN
		Fifthslot:= 'Slide Rail BROKEN';	
	ELSIF FifthActiveSignalIndex = 22 THEN
		Fifthslot:= 'Pallet Conveyor 1 BROKEN';	
	ELSIF FifthActiveSignalIndex = 23 THEN
		Fifthslot:= 'Pallet Conveyor 2 BROKEN';
	ELSE
		Fifthslot:= '-';						
	END_IF				
	
		
	
	
	
	
END_FUNCTION_BLOCK
