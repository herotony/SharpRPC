using System;
using System.Text;



namespace HttpRealBizServer
{
	public class ProcessHttpRequest : IProcessHttpRequest
	{
		public ProcessHttpRequest ()
		{
		}

		public ResponseInfo VisitServer(string protocolName,string sessionId,string Pid,string[] otherParam){

			ResponseInfo res = new ResponseInfo ();

			StringBuilder sb = new StringBuilder ();

			foreach (string param in otherParam)
				sb.AppendFormat ("\r\n param:{0}", param);

			res.ServerReceiveTime = DateTime.Now;

			res.IsOk = true;
			res.MessageBody = string.Format ("protocolName:{0} sessionId:{1} pid:{2} \r\n {3}", protocolName, sessionId, Pid,sb.ToString());

			res.Error = string.Empty;

			res.ServerResponseTime = DateTime.Now;

			res.MillionSecondesOfServerProcess = res.ServerResponseTime.Subtract (res.ServerReceiveTime).TotalMilliseconds;

			return res;
		}
	}
}

