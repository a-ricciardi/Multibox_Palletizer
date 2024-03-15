#ifndef _MNGINTERNALTYP_HPP_
#define _MNGINTERNALTYP_HPP_

#include <AsIecCon.h>
#include <AsBrStr.h>

#include "MNG_Global.hpp"

typedef enum {
	MNG_DeadManDatagram = 0,
	MNG_TimeTick,
	MNG_TimeTickRequest,
	MNG_InitConnection,
	MNG_ResetSimulation,
	MNG_RewindSimulation,
	MNG_StartSimulation,
	MNG_StopSimulation,
	MNG_IOConfig,
	MNG_RawIOImage,
	MNG_Raw32BitImage,
	MNG_TextDatagram,
	MNG_UnknownDatagram
}MNG_DatagramType;

typedef struct {
	unsigned long int Counter;
	unsigned long int SentTime;
	unsigned long int DatagramType;
	unsigned long int ByteCount;
}MNG_DatagramHeader;

typedef unsigned long int MNG_DataArray[1400];

typedef struct {
	MNG_DatagramHeader Header;
	MNG_DataArray Payload;
}MNG_RawDatagram;

#endif
