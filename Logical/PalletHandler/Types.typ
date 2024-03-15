
TYPE
	PalletState : 
		(
		P_StopSequence := 1,
		P_StopDONE := 2,
		P_ResetConfig1 := 3,
		P_ResetConfig2 := 4,
		P_ResetConfig3 := 5,
		P_RestoreConfig1 := 6,
		P_RestoreConfig2 := 7,
		P_RestoreConfig3 := 8,
		P_WaitStart := 9,
		P_WaitLifterDown := 10,
		P_ForkOpen := 11,
		P_WaitLifterUp := 12,
		P_ForkClose := 13,
		P_WaitLifterIdle := 14,
		P_WaitConveyor1 := 15,
		P_WaitConveyor2 := 16,
		P_WaitLightBarrier2 := 17,
		P_WaitStopConveyor1 := 18,
		P_WaitConveyor2SlowDown := 19,
		P_WaitLightBarrier1 := 20,
		P_WaitStopConveyor2 := 21,
		P_WaitBoxes := 22,
		P_WaitRestartConveyor2 := 23,
		P_WaitNOTLightBarrier2 := 24,
		P_WaitExitVelocity := 25
		);
END_TYPE
