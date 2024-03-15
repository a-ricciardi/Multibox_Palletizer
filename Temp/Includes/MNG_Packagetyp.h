/* Automation Studio generated header file */
/* Do not edit ! */

#ifndef _BUR_1687707080_4_
#define _BUR_1687707080_4_

#include <bur/plctypes.h>

/* Datatypes and datatypes of function blocks */
typedef struct ComTCP_INPUTS_32BIT
{	signed short NumSignals;
	plcbit laser_sensor_IR;
	plcbit laser_sensor2_IR;
	float carriage_2_AXIS;
	plcbit carriage_2_RCHD;
	plcbit turnpusher_LBK;
	plcbit turnpusher_LFR;
	float gantry_crane_AXIS;
	float box_crane_AXIS;
	plcbit vaccum_box_crane_VACUUM;
	plcbit pallet_light_barrier_1_IR;
	plcbit pallet_light_barrier_2_IR;
	plcbit pusher_LBK;
	plcbit pusher_LFR;
	float pallet_lifter_AXIS;
	plcbit pallet_fork_left_FB;
} ComTCP_INPUTS_32BIT;

typedef struct ComTCP_OUTPUTS_32BIT
{	signed short NumSignals;
	plcbit cartboard_TRIG;
	plcbit conveyor_if_FWD;
	plcbit conveyer_turn1_FWD;
	plcbit conveyer_end_FWD;
	float carriage_2_TGT_POS;
	plcbit turnpusher_FWD;
	plcbit turnpusher_BWD;
	float gantry_crane_TGT_POS;
	float box_crane_TGT_POS;
	plcbit slide_rail_right_EN;
	plcbit vaccum_box_crane_GRIP;
	plcbit pusher_z_EN;
	plcbit pusher_x_EN;
	float pallet_conveyor_2_ACT_VEL;
	plcbit pusher_FW;
	float pallet_lifter_TGT_POS;
	plcbit pallet_fork_left_EN;
	plcbit pallet_conveyor_1_FWD;
} ComTCP_OUTPUTS_32BIT;






__asm__(".section \".plc\"");

/* Used IEC files */
__asm__(".ascii \"iecfile \\\"Logical/MNG_Package.typ\\\" scope \\\"global\\\"\\n\"");

/* Exported library functions and function blocks */

__asm__(".previous");


#endif /* _BUR_1687707080_4_ */

