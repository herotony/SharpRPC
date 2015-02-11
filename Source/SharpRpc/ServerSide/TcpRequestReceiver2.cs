using System;
using System.Text;
using System.Threading.Tasks;
using System.Collections.Generic;

using SharpRpc.Interaction;
using SharpRpc.Logs;

using AsyncSocketLibrary.Common;
using AsyncSocketLibrary.Common.Server;

namespace SharpRpc.ServerSide
{
	public class TcpRequestReceiver2:IRequestReceiver
	{
		private readonly IIncomingRequestProcessor requestProcessor;
		private readonly ILogger logger;
		private SocketListener listener;
		private bool isAlreadyStart = false;

		public TcpRequestReceiver2 (IIncomingRequestProcessor requestProcessor, ILogger logger)
		{
			this.requestProcessor = requestProcessor;
			this.logger = logger;
		}

		private byte[] Processor(byte[] input){

			Request request = null;

			if (!TryDecodeRequest (input, out request)) {

				return BitConverter.GetBytes ((int)ResponseStatus.BadRequest);
			}

			Task<Response> task = requestProcessor.Process (request);
			Response response = task.Result;

			byte[] statusByte = BitConverter.GetBytes ((int)response.Status);
			byte[] result = new byte[statusByte.Length + response.Data.Length];

			Array.Copy (statusByte, 0, result, 0, statusByte.Length);
			Array.Copy (response.Data, 0, result, statusByte.Length, response.Data.Length);

			return result;
		}

		public void Start(int port,int threads){

			if (isAlreadyStart)
				return;

			listener = new SocketListener (Processor);
			isAlreadyStart = true;
		}

		public void Stop(){
						
			listener.Stop ();
			listener = null;

			isAlreadyStart = false;
		}

		private bool TryDecodeRequest(byte[] input,out Request request){

			int dataLen = BitConverter.ToInt32 (input, 0);
			string urlStr = Encoding.UTF8.GetString (input, 4, dataLen);
			Uri uri = new Uri (urlStr);

			ServicePath servicePath;
			if (!ServicePath.TryParse(uri.LocalPath, out servicePath))
			{
				request = null;
				return false;
			}	

			string scope = string.IsNullOrEmpty(uri.Query)||uri.Query.Length<8?"":uri.Query.Substring(7);

			byte[] data = new byte[input.Length - dataLen];
			Array.Copy (input, dataLen, data, 0, input.Length - dataLen);
			request = new Request (servicePath, scope, data);
			return true;
		}
	}
}

