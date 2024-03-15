
#include "MNG_InternalTyp.hpp"

unsigned long int MNG_CpyMsgToInp(MNG_RawDatagram * pFromServer, ComTCP_INPUTS_32BIT_FWRD *pSimInputs) {

    MNG_DatagramType datagramType;
	unsigned long int DWordBuffer;
        unsigned long int byteCount;
	unsigned long int numSignalsInMessage;


	byteCount = N_TO_HUDINT((pFromServer->Header).ByteCount);
	datagramType = static_cast<MNG_DatagramType>(N_TO_HUDINT((pFromServer->Header).DatagramType));
	if (datagramType != MNG_Raw32BitImage) {
		return 0;
	}

    pSimInputs->NumSignals = 15;

    numSignalsInMessage = N_TO_HUDINT(pFromServer->Payload[0]);
        if ((static_cast<long int>(numSignalsInMessage) != pSimInputs->NumSignals) ||
	(byteCount != 4 + numSignalsInMessage * 4)) {
		return 0;
	}

    /* BOOL laser_sensor_IR */
    pSimInputs->laser_sensor_IR = (pFromServer->Payload[1] != 0);

    /* BOOL laser_sensor2_IR */
    pSimInputs->laser_sensor2_IR = (pFromServer->Payload[2] != 0);

    /* FLOAT32 carriage_2_AXIS */
    DWordBuffer = N_TO_HUDINT(pFromServer->Payload[3]);
    brsmemcpy((unsigned long int)&(pSimInputs->carriage_2_AXIS), (unsigned long int)&(DWordBuffer), 4);

    /* BOOL carriage_2_RCHD */
    pSimInputs->carriage_2_RCHD = (pFromServer->Payload[4] != 0);

    /* BOOL turnpusher_LBK */
    pSimInputs->turnpusher_LBK = (pFromServer->Payload[5] != 0);

    /* BOOL turnpusher_LFR */
    pSimInputs->turnpusher_LFR = (pFromServer->Payload[6] != 0);

    /* FLOAT32 gantry_crane_AXIS */
    DWordBuffer = N_TO_HUDINT(pFromServer->Payload[7]);
    brsmemcpy((unsigned long int)&(pSimInputs->gantry_crane_AXIS), (unsigned long int)&(DWordBuffer), 4);

    /* FLOAT32 box_crane_AXIS */
    DWordBuffer = N_TO_HUDINT(pFromServer->Payload[8]);
    brsmemcpy((unsigned long int)&(pSimInputs->box_crane_AXIS), (unsigned long int)&(DWordBuffer), 4);

    /* BOOL vaccum_box_crane_VACUUM */
    pSimInputs->vaccum_box_crane_VACUUM = (pFromServer->Payload[9] != 0);

    /* BOOL pallet_light_barrier_1_IR */
    pSimInputs->pallet_light_barrier_1_IR = (pFromServer->Payload[10] != 0);

    /* BOOL pallet_light_barrier_2_IR */
    pSimInputs->pallet_light_barrier_2_IR = (pFromServer->Payload[11] != 0);

    /* BOOL pusher_LBK */
    pSimInputs->pusher_LBK = (pFromServer->Payload[12] != 0);

    /* BOOL pusher_LFR */
    pSimInputs->pusher_LFR = (pFromServer->Payload[13] != 0);

    /* FLOAT32 pallet_lifter_AXIS */
    DWordBuffer = N_TO_HUDINT(pFromServer->Payload[14]);
    brsmemcpy((unsigned long int)&(pSimInputs->pallet_lifter_AXIS), (unsigned long int)&(DWordBuffer), 4);

    /* BOOL pallet_fork_left_FB */
    pSimInputs->pallet_fork_left_FB = (pFromServer->Payload[15] != 0);


return N_TO_HUDINT((pFromServer->Header).Counter); // return counter
}
