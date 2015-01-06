using System;

using SharpRpc.Interaction;
using SharpRpc.ServerSide;
using SharpRpc.Logs;

namespace TcpManager
{
	public class TcpRequestReceiver : IRequestReceiver
	{
		private readonly IIncomingRequestProcessor requestProcessor;
		private readonly ILogger logger;

		public TcpRequestReceiver (IIncomingRequestProcessor requestProcessor, ILogger logger)
		{
			this.requestProcessor = requestProcessor;
			this.logger = logger;
		}

		public void Start(int port,int threads){}

		public void Stop(){}
	}
}

