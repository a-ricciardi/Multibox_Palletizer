
PROGRAM _CYCLIC

	(*** FEEDER ***)
	ComTCP_SimOutputs.conveyor_if_FWD	 := Feeder_ConveyorIF_Fwd; 	 		(* box conveyor (conveyor_if) activation *)
	ComTCP_SimOutputs.conveyer_turn1_FWD := Feeder_ConveyorTurn1_Fwd; 		(* second conveyor activation *)
	ComTCP_SimOutputs.conveyer_end_FWD	 := Feeder_ConveyorEndFwd; 	 		(* third conveyor activation *)
	ComTCP_SimOutputs.pusher_FW			 := Feeder_PusherFwd;				(* pusher activation *)
	ComTCP_SimOutputs.turnpusher_BWD	 := Feeder_TurnpusherBwd; 	 		(* move turnpusher in backward position *)
	ComTCP_SimOutputs.turnpusher_FWD	 := Feeder_TurnpusherFwd; 	 	    (* move turnpusher in forward position *)
	ComTCP_SimOutputs.carriage_2_TGT_POS := Feeder_Carriage_Axis_TgtPos;    (* target position for the box group pusher *)

	
	(*** CRANE ***)
	ComTCP_SimOutputs.vaccum_box_crane_GRIP	:= Crane_VacuumGrip; 		 	(* BOOL vaccum_box_crane_GRIP *)
	ComTCP_SimOutputs.slide_rail_right_EN	:= Crane_SlideRail_EN; 		 	(* BOOL slide_rail_right_EN *)
	ComTCP_SimOutputs.pusher_x_EN			:= Crane_PusherX_EN; 		 	(* BOOL pusher_x_EN *)
	ComTCP_SimOutputs.pusher_z_EN			:= Crane_PusherZ_EN; 		 	(* BOOL pusher_z_EN *)
	ComTCP_SimOutputs.cartboard_TRIG		:= Crane_CartboardTrig; 	 	(* BOOL cartboard_TRIG *)
	ComTCP_SimOutputs.gantry_crane_TGT_POS	:= Crane_Gantry_Axis_TgtPos; 	(* REAL gantry_crane_TGT_POS *)
	ComTCP_SimOutputs.box_crane_TGT_POS		:= Crane_Box_Axis_TgtPos; 	 	(* REAL box_crane_TGT_POS *)
	
	(*** PALLET ***)
	ComTCP_SimOutputs.pallet_fork_left_EN		:= Pallet_Fork_EN;			     (* BOOL pallet_fork_left_EN *)
	ComTCP_SimOutputs.pallet_conveyor_1_FWD		:= Pallet_Conveyor1_Fwd; 		 (* BOOL pallet_conveyor_1_FWD *)
	ComTCP_SimOutputs.pallet_conveyor_2_ACT_VEL	:= Pallet_Conveyor2_ActVel;		 (* REAL pallet_conveyor_2_ACT_VEL *)
	ComTCP_SimOutputs.pallet_lifter_TGT_POS		:= Pallet_Lifter_Axis_TgtPos;	 (* REAL pallet_lifter_TGT_POS *)
	
END_PROGRAM