
PROGRAM _CYCLIC

	(*** FEEDER ***)
	LaserSensor1				:= ComTCP_SimInputs.laser_sensor_IR;  (* box present at the end of the first conveyor (conveyor_if) *)
	LaserSensor2 				:= ComTCP_SimInputs.laser_sensor2_IR; (* product passing from conveyor_turn1 towards conveyor_end *)
	Feeder_Carriage_Axis		:= ComTCP_SimInputs.carriage_2_AXIS;  (* actual position of the box group pusher *)
	Feeder_Carriage_Reached		:= ComTCP_SimInputs.carriage_2_RCHD;  (* box group pusher target position reached *)
	Pusher_BKW					:= ComTCP_SimInputs.pusher_LBK;       (* pusher in backward position *)
	Pusher_FWD					:= ComTCP_SimInputs.pusher_LFR; 	  (* pusher in forward position *)
	Turnpusher_BWD				:= ComTCP_SimInputs.turnpusher_LBK;   (* turnpusher in backward position *)
	Turnpusher_FWD				:= ComTCP_SimInputs.turnpusher_LFR;   (* turnpusher in forward position *)
	
	(*** CRANE ***)
	Crane_Vacuum				:= ComTCP_SimInputs.vaccum_box_crane_VACUUM; (* BOOL vaccum_box_crane_VACUUM *)
	Crane_Box_Axis				:= ComTCP_SimInputs.box_crane_AXIS; 		 (* REAL box_crane_AXIS *)
	Crane_Gantry_Axis			:= ComTCP_SimInputs.gantry_crane_AXIS; 		 (* REAL gantry_crane_AXIS *)
	
	(*** PALLET ***)
//	Pallet_Fork_EN				:= ComTCP_SimInputs.pallet_fork_left_FB; 		(* BOOL pallet_fork_left_FB *)
	Pallet_ForkFB				:= ComTCP_SimInputs.pallet_fork_left_FB; 		(* BOOL pallet_fork_left_FB *)
	LightBarrier1				:= ComTCP_SimInputs.pallet_light_barrier_1_IR;  (* BOOL pallet_light_barrier_1_IR *)
	LightBarrier2				:= ComTCP_SimInputs.pallet_light_barrier_2_IR;  (* BOOL pallet_light_barrier_2_IR *)
	Pallet_Lifter_Axis			:= ComTCP_SimInputs.pallet_lifter_AXIS; 		(* REAL pallet_lifter_AXIS *)

END_PROGRAM