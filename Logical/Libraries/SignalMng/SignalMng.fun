
{REDUND_ERROR} FUNCTION_BLOCK SignalManager (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		OperationType : {REDUND_UNREPLICABLE} INT;
		SignalType : {REDUND_UNREPLICABLE} DINT := 0;
		SignalCode : {REDUND_UNREPLICABLE} INT := 0;
		SignalOutput : {REDUND_UNREPLICABLE} DWORD := 0;
		ActivationSignal : {REDUND_UNREPLICABLE} BOOL := FALSE;
		AutoResetSignal : {REDUND_UNREPLICABLE} BOOL := FALSE;
		Reset : {REDUND_UNREPLICABLE} BOOL;
		KeyReset : {REDUND_UNREPLICABLE} BOOL;
	END_VAR
	VAR_OUTPUT
		SignalOutputs : {REDUND_UNREPLICABLE} DWORD;
		SignalPriorityCode : {REDUND_UNREPLICABLE} WORD;
		ResetEnable : {REDUND_UNREPLICABLE} BOOL;
		AuxResetEnable : {REDUND_UNREPLICABLE} BOOL;
		SignalTypeAlarm : {REDUND_UNREPLICABLE} BOOL;
		SignalTypeAnomaly : {REDUND_UNREPLICABLE} BOOL;
		SignalTypeWarning : {REDUND_UNREPLICABLE} BOOL;
		SignalTypeInformation : {REDUND_UNREPLICABLE} BOOL;
		NumberOfAlarms : {REDUND_UNREPLICABLE} INT;
		NumberOfAnomalies : {REDUND_UNREPLICABLE} INT;
		NumberOfWarnings : {REDUND_UNREPLICABLE} INT;
		NumberOfInformation : {REDUND_UNREPLICABLE} INT;
		ActiveSignalCodes : {REDUND_UNREPLICABLE} ARRAY[1..20] OF INT;
		NumberOfActiveAlarms : {REDUND_UNREPLICABLE} INT := 0;
		NumberOfActiveAnomalies : {REDUND_UNREPLICABLE} INT := 0;
		NumberOfActiveWarning : {REDUND_UNREPLICABLE} INT := 0;
		NumberOfActiveInformation : {REDUND_UNREPLICABLE} INT := 0;
		SignalManagementError : {REDUND_UNREPLICABLE} BOOL;
		FirstSignalIndex : INT;
		FirstActiveSignalIndex : INT;
		SecondActiveSignalIndex : INT;
		ThirdActiveSignalIndex : INT;
		FourthActiveSignalIndex : INT;
		FifthActiveSignalIndex : INT;
	END_VAR
	VAR
		ResetSignalsEnable : {REDUND_UNREPLICABLE} BOOL;
		AuxResetActivation : {REDUND_UNREPLICABLE} BOOL;
		ResetActivation : {REDUND_UNREPLICABLE} BOOL;
		SignalRequest : {REDUND_UNREPLICABLE} BOOL;
		SignalAckRequest : {REDUND_UNREPLICABLE} BOOL;
		Signals : {REDUND_UNREPLICABLE} ARRAY[1..23] OF BOOL;
		LastSignalIndex : {REDUND_UNREPLICABLE} INT;
		ActiveSignalRequest : {REDUND_UNREPLICABLE} BOOL;
		ActiveSignalRequestAck : {REDUND_UNREPLICABLE} BOOL;
		LastActiveSignalIndex : {REDUND_UNREPLICABLE} INT;
		ResetOld : {REDUND_UNREPLICABLE} BOOL;
		KeyResetOld : {REDUND_UNREPLICABLE} BOOL;
		Index : {REDUND_UNREPLICABLE} INT;
		BaseIndex : {REDUND_UNREPLICABLE} INT;
		Condition : {REDUND_UNREPLICABLE} BOOL := FALSE;
		i : {REDUND_UNREPLICABLE} INT;
		LastInformationIndex : {REDUND_UNREPLICABLE} INT;
		LastAnomalyIndex : {REDUND_UNREPLICABLE} INT;
		LastWarningIndex : {REDUND_UNREPLICABLE} INT;
		AuxResetRequired : {REDUND_UNREPLICABLE} BOOL;
		Firstslot : STRING[79];
		Secondslot : STRING[79];
		Thirdslot : STRING[79];
		Fourthslot : STRING[79];
		Fifthslot : STRING[80];
	END_VAR
END_FUNCTION_BLOCK
