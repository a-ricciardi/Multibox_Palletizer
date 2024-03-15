
#include "MNG_InternalTyp.hpp"

unsigned long int MNG_CpyOutToMsg(MNG_RawDatagram * pToServer, unsigned long int counter, ComTCP_OUTPUTS_32BIT_FWRD *pSimOutputs ) {

    
        unsigned long int DWordBuffer;
	
        pSimOutputs->NumSignals = 18;
        (pToServer->Header).ByteCount    = H_TO_NUDINT(76);
        (pToServer->Header).DatagramType = H_TO_NUDINT(MNG_Raw32BitImage);
        (pToServer->Header).SentTime = H_TO_NUDINT(0);  // Todo
        (pToServer->Header).Counter = H_TO_NUDINT(counter);
        pToServer->Payload[0] = H_TO_NUDINT(pSimOutputs->NumSignals);

    
    /* cartboard_TRIG : BOOL */
    if(pSimOutputs->cartboard_TRIG == 1) {
        pToServer->Payload[1] = 0xFFFFFFFF;   /*BOOL */
    } else { 
        pToServer->Payload[1] = 0;
    }


    /* conveyor_if_FWD : BOOL */
    if(pSimOutputs->conveyor_if_FWD == 1) {
        pToServer->Payload[2] = 0xFFFFFFFF;   /*BOOL */
    } else { 
        pToServer->Payload[2] = 0;
    }


    /* conveyer_turn1_FWD : BOOL */
    if(pSimOutputs->conveyer_turn1_FWD == 1) {
        pToServer->Payload[3] = 0xFFFFFFFF;   /*BOOL */
    } else { 
        pToServer->Payload[3] = 0;
    }


    /* conveyer_end_FWD : BOOL */
    if(pSimOutputs->conveyer_end_FWD == 1) {
        pToServer->Payload[4] = 0xFFFFFFFF;   /*BOOL */
    } else { 
        pToServer->Payload[4] = 0;
    }


    /* carriage_2_TGT_POS : FLOAT32 */
    brsmemcpy((unsigned long int)&(DWordBuffer), (unsigned long int)&(pSimOutputs->carriage_2_TGT_POS), 4);
    pToServer->Payload[5] = H_TO_NUDINT(DWordBuffer);


    /* turnpusher_FWD : BOOL */
    if(pSimOutputs->turnpusher_FWD == 1) {
        pToServer->Payload[6] = 0xFFFFFFFF;   /*BOOL */
    } else { 
        pToServer->Payload[6] = 0;
    }


    /* turnpusher_BWD : BOOL */
    if(pSimOutputs->turnpusher_BWD == 1) {
        pToServer->Payload[7] = 0xFFFFFFFF;   /*BOOL */
    } else { 
        pToServer->Payload[7] = 0;
    }


    /* gantry_crane_TGT_POS : FLOAT32 */
    brsmemcpy((unsigned long int)&(DWordBuffer), (unsigned long int)&(pSimOutputs->gantry_crane_TGT_POS), 4);
    pToServer->Payload[8] = H_TO_NUDINT(DWordBuffer);


    /* box_crane_TGT_POS : FLOAT32 */
    brsmemcpy((unsigned long int)&(DWordBuffer), (unsigned long int)&(pSimOutputs->box_crane_TGT_POS), 4);
    pToServer->Payload[9] = H_TO_NUDINT(DWordBuffer);


    /* slide_rail_right_EN : BOOL */
    if(pSimOutputs->slide_rail_right_EN == 1) {
        pToServer->Payload[10] = 0xFFFFFFFF;   /*BOOL */
    } else { 
        pToServer->Payload[10] = 0;
    }


    /* vaccum_box_crane_GRIP : BOOL */
    if(pSimOutputs->vaccum_box_crane_GRIP == 1) {
        pToServer->Payload[11] = 0xFFFFFFFF;   /*BOOL */
    } else { 
        pToServer->Payload[11] = 0;
    }


    /* pusher_z_EN : BOOL */
    if(pSimOutputs->pusher_z_EN == 1) {
        pToServer->Payload[12] = 0xFFFFFFFF;   /*BOOL */
    } else { 
        pToServer->Payload[12] = 0;
    }


    /* pusher_x_EN : BOOL */
    if(pSimOutputs->pusher_x_EN == 1) {
        pToServer->Payload[13] = 0xFFFFFFFF;   /*BOOL */
    } else { 
        pToServer->Payload[13] = 0;
    }


    /* pallet_conveyor_2_ACT_VEL : FLOAT32 */
    brsmemcpy((unsigned long int)&(DWordBuffer), (unsigned long int)&(pSimOutputs->pallet_conveyor_2_ACT_VEL), 4);
    pToServer->Payload[14] = H_TO_NUDINT(DWordBuffer);


    /* pusher_FW : BOOL */
    if(pSimOutputs->pusher_FW == 1) {
        pToServer->Payload[15] = 0xFFFFFFFF;   /*BOOL */
    } else { 
        pToServer->Payload[15] = 0;
    }


    /* pallet_lifter_TGT_POS : FLOAT32 */
    brsmemcpy((unsigned long int)&(DWordBuffer), (unsigned long int)&(pSimOutputs->pallet_lifter_TGT_POS), 4);
    pToServer->Payload[16] = H_TO_NUDINT(DWordBuffer);


    /* pallet_fork_left_EN : BOOL */
    if(pSimOutputs->pallet_fork_left_EN == 1) {
        pToServer->Payload[17] = 0xFFFFFFFF;   /*BOOL */
    } else { 
        pToServer->Payload[17] = 0;
    }


    /* pallet_conveyor_1_FWD : BOOL */
    if(pSimOutputs->pallet_conveyor_1_FWD == 1) {
        pToServer->Payload[18] = 0xFFFFFFFF;   /*BOOL */
    } else { 
        pToServer->Payload[18] = 0;
    }


	return 0;
}
