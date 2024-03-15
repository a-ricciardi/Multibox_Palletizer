
#ifndef _MNGCOMHDLR_HPP_
#define _MNGCOMHDLR_HPP_

#define TRUE  1
#define FALSE 0

#include "MNG_InternalTyp.hpp"

#include <bur/plc.h>
#include <bur/plctypes.h>
#include <AsTCP.h>
#include <standard.h>
#include <astime.h>
#include <runtime.h>
#include <AsBrStr.h>

typedef struct{
	TcpOpen_typ tcpOpen;
	TcpIoctl_typ tcpIoctl;
	tcpLINGER_typ tcpLINGER;
	TcpSend_typ tcpSend;
	TcpClose_typ tcpClose;
	TcpRecv_typ tcpRecv;
	TcpClient_typ tcpClient;
} asTcpFcn_t;


typedef enum {
	MNG_wSock,
	MNG_skippedMessage
} MNG_errorCases;

typedef enum {
	MNG_Init,
	MNG_Socket,
	MNG_Open,
	MNG_SetIo,
	MNG_Linger,
	MNG_Connecting,
	MNG_Exchange,
	MNG_Closing,
        MNG_Reset
} MNG_internalState_t;

	extern unsigned long int MNG_CpyOutToMsg(MNG_RawDatagram * pToServer, unsigned long int counter, ComTCP_OUTPUTS_32BIT_FWRD *pSimOutputs);
	extern unsigned long int MNG_CpyMsgToInp(MNG_RawDatagram * pFromServer, ComTCP_INPUTS_32BIT_FWRD *pSimInputs); 

class MNG_ComHdlr
{
	public:
	
	MNG_ComHdlr(char *srvIpAdr, unsigned int srvPort, TIME sendCycleTime);
	~MNG_ComHdlr();
	
        int RunCommunication(void*, void*, BOOL*);
	
	private:
		
	char* _srvIpAdr;
	unsigned int _srvPort;
	TIME _sendCycleTime;
		
	unsigned int _error;
	
	MNG_internalState_t _internalState;
	TON_typ _connectionTon;
	TIME _connectionTime;
		
	bool _connect;
	bool _sendDone;
	
	signed int _recvOffset;
	
	signed long int _potMsgLen;
	signed long int _totalRecvLen;

	unsigned long int _one;
	unsigned long int _counter;
	unsigned long int _recvLen;
	unsigned long int _recvBuffer[10000];
	TON_typ _sendTon;
	MNG_RawDatagram _recvMessage;
	MNG_RawDatagram _sendMessage;
		
	static const signed long int SIXTEEN = 16;
	static const unsigned int PORT = 0;
	static const unsigned long int MNG_MAXPAYLOAD = 1400;
	
	void init_TcpOpen();
	void init_TcpSocket();
	void init_TcpIoctl();
	void init_TcpLinger();
	void init_TcpClient();
	void init_TcpRecv();
	void init_TcpSend(ComTCP_OUTPUTS_32BIT_FWRD* pSimOut);
	
	void InitParams();
		
	void SetSendDone(bool toogle);
	void SetStateValue(MNG_internalState_t stateVal);
	
};
#endif
