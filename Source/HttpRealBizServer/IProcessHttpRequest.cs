using System;

namespace HttpRealBizServer
{
	public interface IProcessHttpRequest
	{
		ResponseInfo VisitServer(string protocolName,string sessionId,string Pid,string[] otherParam);
	}

	public struct ResponseInfo{

		public bool IsOk;
		public string Error;
		public string MessageBody;
		public DateTime ServerReceiveTime;
		public DateTime ServerResponseTime;
		public double MillionSecondesOfServerProcess;
	}
}

