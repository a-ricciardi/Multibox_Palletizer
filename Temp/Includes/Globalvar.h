/* Automation Studio generated header file */
/* Do not edit ! */

#ifndef _BUR_1687707080_2_
#define _BUR_1687707080_2_

#include <bur/plctypes.h>

/* Constants */
#ifdef _REPLACE_CONST
#else
#endif


/* Variables */
_GLOBAL plcbit OutOfMaterial;
_GLOBAL plcbit SIMPalletConveyor2Fault;
_GLOBAL plcbit SIMCartboardFault;
_GLOBAL plcbit SIMPalletLifterFault;
_GLOBAL plcbit SIMPalletConveyor1Fault;
_GLOBAL plcbit SIMPalletForkFault;
_GLOBAL plcbit SIMBoxCraneFault;
_GLOBAL plcbit SIMGantryCraneFault;
_GLOBAL plcbit SIMPusherXFault;
_GLOBAL plcbit SIMPusherZFault;
_GLOBAL plcbit SIMSlideRailFault;
_GLOBAL plcbit SIMVacuumFault;
_GLOBAL plcbit SIMCarriageFault;
_GLOBAL plcbit SIMTurnpusherFault;
_GLOBAL plcbit SIMConveyorEndFault;
_GLOBAL plcbit SIMFeederPusherFault;
_GLOBAL plcbit SIMConveyorTurn1Fault;
_GLOBAL plcbit SIMConveyorIFFault;
_GLOBAL plcbit PalletExit_DONE;
_GLOBAL plcbit PalletExit_EN;
_GLOBAL plcbit BoxesOnPallet;
_GLOBAL plcbit SecondLayer;
_GLOBAL plcbit LoadBoxesOnPallet;
_GLOBAL plcbit PalletReady;
_GLOBAL plcbit HoldBoxes;
_GLOBAL plcbit BoxesOnCrane;
_GLOBAL plcbit LoadBoxesOnCrane;
_GLOBAL plcbit FeederReady;
_GLOBAL plcbit CraneReady;
_GLOBAL plcbit StartMachine;
_GLOBAL signed short BoxCounter;
_GLOBAL plcbit CraneLayerCounter;
_GLOBAL plcbit StartFeeder;
_GLOBAL signed short CraneCartboardCounter;
_GLOBAL plcbit StartCrane;
_GLOBAL signed short PalletCounter;
_GLOBAL plcbit StartPallet;
_GLOBAL plcbit PalletConveyor1_disable_request;
_GLOBAL plcbit PalletConveyor1_enable_request;
_GLOBAL plcbit PalletFork_disable_request;
_GLOBAL plcbit PalletFork_enable_request;
_GLOBAL plcbit PusherX_disable_request;
_GLOBAL plcbit PusherX_enable_request;
_GLOBAL plcbit PusherZ_disable_request;
_GLOBAL plcbit PusherZ_enable_request;
_GLOBAL plcbit SlideRail_disable_request;
_GLOBAL plcbit SlideRail_enable_request;
_GLOBAL plcbit Cartboard_disable_request;
_GLOBAL plcbit Cartboard_enable_request;
_GLOBAL plcbit Vacuum_disable_request;
_GLOBAL plcbit Vacuum_enable_request;
_GLOBAL plcbit Turnpusher_disable_request;
_GLOBAL plcbit Turnpusher_enable_request;
_GLOBAL plcbit Conveyor_end_disable_request;
_GLOBAL plcbit Conveyor_end_enable_request;
_GLOBAL plcbit Pusher_disable_request;
_GLOBAL plcbit Pusher_enable_request;
_GLOBAL plcbit Conveyor_turn1_disable_request;
_GLOBAL plcbit Conveyor_turn1_enable_request;
_GLOBAL plcbit Conveyor_if_disable_request;
_GLOBAL plcbit Conveyor_if_enable_request;
_GLOBAL plcbit act_VacuumFault;
_GLOBAL plcbit act_ConveyorTurn1Fault;
_GLOBAL plcbit act_PalletConveyor1Fault;
_GLOBAL plcbit act_ConveyorEndFault;
_GLOBAL plcbit act_ConveyorIFFault;
_GLOBAL plcbit act_SlideRailFault;
_GLOBAL plcbit act_TurnpusherFault;
_GLOBAL plcbit act_PusherZFault;
_GLOBAL plcbit act_PusherXFault;
_GLOBAL plcbit act_FeederPusherFault;
_GLOBAL plcbit act_PalletLifterFault;
_GLOBAL plcbit act_PalletForkFault;
_GLOBAL plcbit act_BoxCraneFault;
_GLOBAL plcbit act_GantryCraneFault;
_GLOBAL plcbit act_CarriageFault;
_GLOBAL plcbit act_CartboardFault;
_GLOBAL plcbit act_PalletConveyor2Fault;
_GLOBAL plcbit OnPhaseStop;
_GLOBAL plcbit ImmediateStop;
_GLOBAL plcbit Pallet_OnPhaseStop;
_GLOBAL plcbit Crane_OnPhaseStop;
_GLOBAL plcbit Feeder_OnPhaseStop;
_GLOBAL plcbit Pallet_Restart;
_GLOBAL plcbit Crane_Restart;
_GLOBAL plcbit Feeder_Restart;
_GLOBAL plcbit Pallet_ImmediateStop;
_GLOBAL plcbit Crane_ImmediateStop;
_GLOBAL plcbit Feeder_ImmediateStop;
_GLOBAL plcbit EnableMachine;
_GLOBAL plcbit Pallet_ResetConfig;
_GLOBAL plcbit Crane_ResetConfig;
_GLOBAL plcbit Feeder_ResetConfig;
_GLOBAL plcbit Pallet_EmergencyStop;
_GLOBAL plcbit Crane_EmergencyStop;
_GLOBAL plcbit Feeder_EmergencyStop;
_GLOBAL plcbit EmergencyStop;
_GLOBAL plcbit OutOfCartboard;
_GLOBAL plcbit OutOfPallet;
_GLOBAL signed short OperationType;
_GLOBAL float Pallet_Lifter_Axis_TgtPos;
_GLOBAL float Pallet_Conveyor2_ActVel;
_GLOBAL float Crane_Gantry_Axis_TgtPos;
_GLOBAL float Feeder_Carriage_Axis_TgtPos;
_GLOBAL float Crane_Box_Axis_TgtPos;
_GLOBAL float Pallet_Lifter_Axis;
_GLOBAL float Crane_Gantry_Axis;
_GLOBAL float Crane_Box_Axis;
_GLOBAL plcbit Feeder_Carriage_Reached;
_GLOBAL float Feeder_Carriage_Axis;
_GLOBAL plcbit Pallet_Conveyor1_Fwd;
_GLOBAL plcbit Pallet_Fork_EN;
_GLOBAL plcbit Crane_PusherX_EN;
_GLOBAL plcbit Crane_PusherZ_EN;
_GLOBAL plcbit Crane_SlideRail_EN;
_GLOBAL plcbit Crane_CartboardTrig;
_GLOBAL plcbit Crane_VacuumGrip;
_GLOBAL plcbit Feeder_TurnpusherBwd;
_GLOBAL plcbit Feeder_TurnpusherFwd;
_GLOBAL plcbit Feeder_ConveyorEndFwd;
_GLOBAL plcbit Feeder_PusherFwd;
_GLOBAL plcbit Feeder_ConveyorTurn1_Fwd;
_GLOBAL plcbit Feeder_ConveyorIF_Fwd;
_GLOBAL plcbit Pallet_ForkFB;
_GLOBAL plcbit Crane_Vacuum;
_GLOBAL plcbit Turnpusher_BWD;
_GLOBAL plcbit Turnpusher_FWD;
_GLOBAL plcbit Pusher_FWD;
_GLOBAL plcbit Pusher_BKW;
_GLOBAL plcbit LaserSensor2;
_GLOBAL plcbit LaserSensor1;
_GLOBAL plcbit LightBarrier2;
_GLOBAL plcbit LightBarrier1;





__asm__(".section \".plc\"");

/* Used IEC files */
__asm__(".ascii \"iecfile \\\"Logical/Global.var\\\" scope \\\"global\\\"\\n\"");

/* Exported library functions and function blocks */

__asm__(".previous");


#endif /* _BUR_1687707080_2_ */

