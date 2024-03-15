
TYPE
	FeederState : 
		(
		F_StopSequence := 1,
		F_StopDONE := 2,
		F_ResetConfig := 3,
		F_RestoreConfig1 := 4,
		F_RestoreConfig2 := 5,
		F_RestoreConfig3 := 6,
		F_WaitStart := 7,
		F_WaitConveyorIFActive := 8,
		F_WaitBoxPusherPosition := 9,
		F_LayerCheck := 10,
		F_LineCheck := 11,
		F_WaitLaser2 := 12,
		F_BoxPosOk := 13,
		F_WaitConveyorStop := 14,
		F_Idle := 15,
		F_CarriageFwdPosition := 16,
		F_CarriageBwdPosition := 17,
		F_WaitStartPosition := 18
		);
END_TYPE
