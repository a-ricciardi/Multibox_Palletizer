
#include "MNG_ComHdlr.hpp"
#include "MNG_CpyMsgToInp.cpp"
#include "MNG_CpyOutToMsg.cpp"

asTcpFcn_t _asTcpFcn;

MNG_ComHdlr::MNG_ComHdlr(char *srvIpAdr, unsigned int srvPort, TIME sendCycleTime)
{
	_srvIpAdr = srvIpAdr;
	_srvPort = srvPort;
	_sendCycleTime = sendCycleTime;
	InitParams();
}


MNG_ComHdlr::~MNG_ComHdlr()
{
}

int MNG_ComHdlr::RunCommunication(void* pSimInputs, void* pSimOutputs, BOOL* pSimActive) {
	
        unsigned long int _lastCounter = _counter;
	
	ComTCP_INPUTS_32BIT_FWRD* pFwrd_SimInputs = static_cast<ComTCP_INPUTS_32BIT_FWRD*>((pSimInputs));
	ComTCP_OUTPUTS_32BIT_FWRD* pFwrd_SimOutputs = static_cast<ComTCP_OUTPUTS_32BIT_FWRD*>((pSimOutputs));
	
	switch (_internalState) {

		case MNG_Init: 
                        *pSimActive = FALSE;
			_asTcpFcn.tcpOpen.enable = FALSE;
			TcpOpen(&_asTcpFcn.tcpOpen);
			_asTcpFcn.tcpIoctl.enable = FALSE;
			TcpIoctl(&_asTcpFcn.tcpIoctl);
			_asTcpFcn.tcpClient.enable = FALSE;
			TcpClient(&_asTcpFcn.tcpClient);
			_asTcpFcn.tcpSend.enable = FALSE;
			TcpSend(&_asTcpFcn.tcpSend);
			_asTcpFcn.tcpRecv.enable = FALSE;
			TcpRecv(&_asTcpFcn.tcpRecv);
			_asTcpFcn.tcpClose.enable = FALSE;
			TcpClose(&_asTcpFcn.tcpClose);
	
			_connectionTon.IN = FALSE;
			_connectionTon.PT = _connectionTime;
			_sendTon.IN = FALSE;
			_sendTon.PT = _sendCycleTime;
			SetStateValue(MNG_Socket);
			break;
		
		case MNG_Socket: 
                        *pSimActive = FALSE;
			init_TcpSocket();
			TcpOpen(&_asTcpFcn.tcpOpen);
			_recvOffset = 0;
			if (_connect == 1) {
				SetStateValue(MNG_Open);
				_connectionTon.IN = FALSE;
			}
			break;
		
		case MNG_Open:
                        *pSimActive = FALSE;
			init_TcpOpen();
			TcpOpen(&_asTcpFcn.tcpOpen);
			if (_asTcpFcn.tcpOpen.status == 0) {
				SetStateValue(MNG_SetIo);	
				_asTcpFcn.tcpIoctl.enable = FALSE;
				TcpIoctl(&_asTcpFcn.tcpIoctl);
				_connectionTon.IN = FALSE;
			}
			break;
		
		case MNG_SetIo:
                        *pSimActive = FALSE;
			init_TcpIoctl();
			TcpIoctl(&_asTcpFcn.tcpIoctl);	
			if (_asTcpFcn.tcpIoctl.status == 0) {
				SetStateValue(MNG_Linger);
				_asTcpFcn.tcpClient.enable = FALSE;
				TcpClient(&_asTcpFcn.tcpClient);
				_connectionTon.IN = FALSE;
			}
			break;
		
		case MNG_Linger:
                        *pSimActive = FALSE;
			init_TcpLinger();
			TcpIoctl(&_asTcpFcn.tcpIoctl);
		
			if (_asTcpFcn.tcpIoctl.status == 0) {
				SetStateValue(MNG_Connecting);		
				_asTcpFcn.tcpClient.enable = FALSE;
				_connectionTon.IN = FALSE;
			}	
			
		case MNG_Connecting: 
                        *pSimActive = FALSE;
			_asTcpFcn.tcpClient.enable = TRUE;
			_asTcpFcn.tcpClient.ident = _asTcpFcn.tcpOpen.ident;
			_asTcpFcn.tcpClient.portserv = _srvPort;
			_asTcpFcn.tcpClient.pServer = (long)_srvIpAdr;
			TcpClient(&_asTcpFcn.tcpClient);
			
			if (_asTcpFcn.tcpClient.status == ERR_FUB_BUSY) {
				// state = state || SetStateValue(Connecting);
			} else if (_asTcpFcn.tcpClient.status == 0) {
				SetStateValue(MNG_Exchange);
				_connectionTon.IN = FALSE;
				SetSendDone(TRUE);
			}
			break;
		
		case MNG_Exchange:
			init_TcpRecv();
			TcpRecv(&_asTcpFcn.tcpRecv);	

			if (_asTcpFcn.tcpRecv.status==0){
                        *pSimActive = FALSE;
			_connectionTon.IN = FALSE;
			_recvLen = _asTcpFcn.tcpRecv.recvlen;
			_potMsgLen = N_TO_HUDINT(_recvBuffer[3]) + SIXTEEN; 
			_totalRecvLen = _recvOffset + _recvLen;

			if ((_totalRecvLen < SIXTEEN) || (_totalRecvLen < _potMsgLen)) {
			_recvOffset = _recvOffset + _recvLen;
			}	else {
			while ((_potMsgLen > 0) && (_potMsgLen <= _totalRecvLen)) {
			// misconfigured message sizes
                        if ((unsigned long int)_potMsgLen > sizeof(_recvMessage)) {
			SetStateValue(MNG_Reset);
			break;
			}
							
			brsmemcpy((unsigned long int) &_recvMessage, (unsigned long int) &_recvBuffer, _potMsgLen*sizeof(unsigned long int));
			_totalRecvLen = _totalRecvLen - _potMsgLen;
			brsmemmove((unsigned long int) &_recvBuffer, (unsigned long int) &_recvBuffer + _potMsgLen, _totalRecvLen*sizeof(unsigned long int));
			_counter = MNG_CpyMsgToInp(&_recvMessage,pFwrd_SimInputs);
                        *pSimActive = (_lastCounter != _counter);
			_recvOffset = _totalRecvLen;
					
			if (_totalRecvLen > SIXTEEN) {
			_potMsgLen = N_TO_HUDINT(_recvBuffer[3]) + SIXTEEN;
			} else {
			_potMsgLen = 0;
			}
						
			}
			}
			}
		
			_sendTon.IN = _sendDone;
			TON(&_sendTon);
	
			if (_sendTon.Q || _asTcpFcn.tcpSend.enable == 1) {
				if (_sendDone==TRUE) {
					SetSendDone(FALSE);
					MNG_CpyOutToMsg(&_sendMessage, _counter,pFwrd_SimOutputs);
					init_TcpSend(pFwrd_SimOutputs);
				}
				TcpSend(&_asTcpFcn.tcpSend);

				if (_asTcpFcn.tcpSend.status == 0) {
					if (_asTcpFcn.tcpSend.datalen != _asTcpFcn.tcpSend.sentlen) {
						// state = state || SetStateValue(Exchange);
					}
					_asTcpFcn.tcpSend.enable = FALSE;
					SetSendDone(TRUE);
				}
			}
			if (_asTcpFcn.tcpRecv.status == tcpERR_NOT_CONNECTED) {
				SetStateValue(MNG_Closing);
			}
			break;
			
		case MNG_Closing:
                        *pSimActive = FALSE;
			_asTcpFcn.tcpClose.enable = TRUE;
			_asTcpFcn.tcpClose.ident = _asTcpFcn.tcpOpen.ident;
			_asTcpFcn.tcpClose.how = 0;
			TcpClose(&_asTcpFcn.tcpClose);

			if(_asTcpFcn.tcpClose.status == 0 || _asTcpFcn.tcpClose.status == 32600){
				SetStateValue(MNG_Init);
			}
			break;

                case MNG_Reset:
                        SetStateValue(MNG_Closing);
                        break;
	}
	
	TON(&_connectionTon);
	_connectionTon.IN = TRUE;
	if (_connectionTon.Q == 1) {
		SetStateValue(MNG_Closing);	
		_connectionTon.IN = FALSE;
	}
	
	return _internalState;
}

void MNG_ComHdlr::init_TcpOpen(){
	_asTcpFcn.tcpOpen.enable = _connect;
}

void MNG_ComHdlr::init_TcpSocket(){
	_asTcpFcn.tcpOpen.enable = TRUE;
	_asTcpFcn.tcpOpen.pIfAddr = 0;
	_asTcpFcn.tcpOpen.port = PORT;
	_asTcpFcn.tcpOpen.options = tcpOPT_REUSEADDR;		
}

void MNG_ComHdlr::init_TcpIoctl(){
	_asTcpFcn.tcpIoctl.enable = TRUE;
	_asTcpFcn.tcpIoctl.pData = (unsigned long int) &_one;
	_asTcpFcn.tcpIoctl.datalen = 4;
	_asTcpFcn.tcpIoctl.ident = _asTcpFcn.tcpOpen.ident;
	_asTcpFcn.tcpIoctl.ioctl = tcpTCP_NODELAY_SET;
}

void MNG_ComHdlr::init_TcpLinger(){
	_asTcpFcn.tcpLINGER.lLinger = FALSE;
	_asTcpFcn.tcpLINGER.lOnOff = TRUE;
	_asTcpFcn.tcpIoctl.enable = TRUE;
	_asTcpFcn.tcpIoctl.pData = (unsigned long int) &_asTcpFcn.tcpLINGER;
	_asTcpFcn.tcpIoctl.datalen = sizeof(_asTcpFcn.tcpLINGER);
	_asTcpFcn.tcpIoctl.ident = _asTcpFcn.tcpOpen.ident;
	_asTcpFcn.tcpIoctl.ioctl = tcpSO_LINGER_SET;
}

void MNG_ComHdlr::init_TcpClient(){
	
	_asTcpFcn.tcpClient.enable = TRUE;
	_asTcpFcn.tcpClient.ident = _asTcpFcn.tcpOpen.ident;
	_asTcpFcn.tcpClient.portserv = _srvPort;
	_asTcpFcn.tcpClient.pServer = (long)_srvIpAdr;
}

void MNG_ComHdlr::init_TcpRecv(){
	
	_asTcpFcn.tcpRecv.enable = TRUE;
	_asTcpFcn.tcpRecv.ident= _asTcpFcn.tcpOpen.ident;
	_asTcpFcn.tcpRecv.datamax = sizeof(_recvBuffer) - _recvOffset;
	_asTcpFcn.tcpRecv.pData = (unsigned long int) &_recvBuffer + _recvOffset;
}

void MNG_ComHdlr::init_TcpSend(ComTCP_OUTPUTS_32BIT_FWRD *pSimOutputs){
	
	_asTcpFcn.tcpSend.enable = TRUE;
	_asTcpFcn.tcpSend.ident= _asTcpFcn.tcpOpen.ident;
	_asTcpFcn.tcpSend.datalen = 16 + ((pSimOutputs->NumSignals) + 1) * 4;
	_asTcpFcn.tcpSend.pData = (unsigned long int)&_sendMessage;
	_asTcpFcn.tcpSend.flags = 0;
}

void MNG_ComHdlr::InitParams(){
	_internalState = MNG_Init;
	_connectionTime = 3000;
	_one=1;		
	_connect = TRUE;
	_potMsgLen = 0;
	_recvLen = 0;		
	_recvOffset = 0;
	_counter = 0;
	SetSendDone(FALSE);
}

void MNG_ComHdlr::SetSendDone(bool toggle){
	_sendDone=toggle;
}

void MNG_ComHdlr::SetStateValue(MNG_internalState_t stateVal){
	_internalState=stateVal;	
}
