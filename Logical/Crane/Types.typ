
TYPE
	CraneState : 
		(
		C_StopSequence := 1,
		C_StopDONE := 2,
		C_ResetConfig := 3,
		C_RestoreConfig1 := 4,
		C_RestoreConfig2 := 5,
		C_RestoreConfig3 := 6,
		C_WaitStart := 7,
		C_WaitGantryCraneStartPosition := 8,
		C_WaitCartboardLoadPosition := 9,
		C_WaitCartboardLoad := 10,
		C_WaitBoxCraneStartPosition := 11,
		C_WaitPusherZStartDown := 12,
		C_WaitPusherXStartFwd := 13,
		C_LockCartboard := 14,
		C_WaitBoxes := 15,
		C_WaitSlideRailHold := 16,
		C_WaitPusherZPushUp := 17,
		C_WaitPusherXPushBwd := 18,
		C_Idle := 19,
		C_WaitPusherZPushDown := 20,
		C_WaitBoxCraneCartboardPos := 21,
		C_WaitGantryCraneCartboardPos := 22,
		C_CartboardPosOk := 23,
		C_BoxesPosOk := 24,
		C_OpenSlideRail := 25,
		C_PusherFwd := 26
		);
END_TYPE
