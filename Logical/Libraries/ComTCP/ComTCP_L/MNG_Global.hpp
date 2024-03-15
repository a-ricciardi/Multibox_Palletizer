
#ifndef  _MNGGLOBAL_HPP_
#define _MNGGLOBAL_HPP_

#include <mng_globalTYP.h>


    typedef struct {

		signed short NumSignals;

        /* BOOL laser_sensor_IR */
        BOOL laser_sensor_IR;
        /* BOOL laser_sensor2_IR */
        BOOL laser_sensor2_IR;
        /* REAL carriage_2_AXIS */
        REAL carriage_2_AXIS;
        /* BOOL carriage_2_RCHD */
        BOOL carriage_2_RCHD;
        /* BOOL turnpusher_LBK */
        BOOL turnpusher_LBK;
        /* BOOL turnpusher_LFR */
        BOOL turnpusher_LFR;
        /* REAL gantry_crane_AXIS */
        REAL gantry_crane_AXIS;
        /* REAL box_crane_AXIS */
        REAL box_crane_AXIS;
        /* BOOL vaccum_box_crane_VACUUM */
        BOOL vaccum_box_crane_VACUUM;
        /* BOOL pallet_light_barrier_1_IR */
        BOOL pallet_light_barrier_1_IR;
        /* BOOL pallet_light_barrier_2_IR */
        BOOL pallet_light_barrier_2_IR;
        /* BOOL pusher_LBK */
        BOOL pusher_LBK;
        /* BOOL pusher_LFR */
        BOOL pusher_LFR;
        /* REAL pallet_lifter_AXIS */
        REAL pallet_lifter_AXIS;
        /* BOOL pallet_fork_left_FB */
        BOOL pallet_fork_left_FB;

        } ComTCP_INPUTS_32BIT_FWRD;


    typedef struct {

		signed short NumSignals;

        /* BOOL cartboard_TRIG */
        BOOL cartboard_TRIG;
        /* BOOL conveyor_if_FWD */
        BOOL conveyor_if_FWD;
        /* BOOL conveyer_turn1_FWD */
        BOOL conveyer_turn1_FWD;
        /* BOOL conveyer_end_FWD */
        BOOL conveyer_end_FWD;
        /* REAL carriage_2_TGT_POS */
        REAL carriage_2_TGT_POS;
        /* BOOL turnpusher_FWD */
        BOOL turnpusher_FWD;
        /* BOOL turnpusher_BWD */
        BOOL turnpusher_BWD;
        /* REAL gantry_crane_TGT_POS */
        REAL gantry_crane_TGT_POS;
        /* REAL box_crane_TGT_POS */
        REAL box_crane_TGT_POS;
        /* BOOL slide_rail_right_EN */
        BOOL slide_rail_right_EN;
        /* BOOL vaccum_box_crane_GRIP */
        BOOL vaccum_box_crane_GRIP;
        /* BOOL pusher_z_EN */
        BOOL pusher_z_EN;
        /* BOOL pusher_x_EN */
        BOOL pusher_x_EN;
        /* REAL pallet_conveyor_2_ACT_VEL */
        REAL pallet_conveyor_2_ACT_VEL;
        /* BOOL pusher_FW */
        BOOL pusher_FW;
        /* REAL pallet_lifter_TGT_POS */
        REAL pallet_lifter_TGT_POS;
        /* BOOL pallet_fork_left_EN */
        BOOL pallet_fork_left_EN;
        /* BOOL pallet_conveyor_1_FWD */
        BOOL pallet_conveyor_1_FWD;

        } ComTCP_OUTPUTS_32BIT_FWRD;



#endif
