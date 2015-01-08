using System;
using System.Text;
using System.Threading;
using System.Net;
using System.Net.Sockets;

using SharpRpc.Interaction;
using SharpRpc.Logs;

namespace SharpRpc.ServerSide
{
	public class TcpRequestReceiver :IRequestReceiver
	{
		private readonly IIncomingRequestProcessor requestProcessor;
		private readonly ILogger logger;
		private TcpListener listener;
		private Thread listenerThread;

		private bool stopFlag = false;

		public TcpRequestReceiver (IIncomingRequestProcessor requestProcessor, ILogger logger)
		{
			this.requestProcessor = requestProcessor;
			this.logger = logger;
		}

		private void DoListen(){

			try{

				listener.Start();
				logger.Info("Listener has started");

				while(true){				

					if(stopFlag)
						break;

					if(!listener.Pending()){

						Thread.Sleep(10);
						continue;
					}						

					AcceptClient();
				}

				listener.Stop();

			}catch(Exception ex){

				logger.Fatal("Listener thread was killed by an exception", ex);
			}finally{

				listener = null;
				stopFlag = false;
			}

			logger.Info("Listener has finished working");
		}

		private  async void AcceptClient(){

			var tcpClient = await listener.AcceptTcpClientAsync ();

			using (var networkSteam = tcpClient.GetStream ()) {

				byte[] buff = new byte[1024 * 1024];
				byte[] statusByte = new byte[0];
				byte[] responseByte = new byte[0];

				var byteCount = await networkSteam.ReadAsync (buff, 0, buff.Length);

				Request request = null;

				if (!TryDecodeRequest (buff,byteCount, out request)) {

					logger.Error (string.Format("Failed to decode request! on {0}", tcpClient.Client.RemoteEndPoint));	

					statusByte = BitConverter.GetBytes((int)ResponseStatus.BadRequest);
					responseByte = new byte[sizeof(int)];

					Array.Copy (statusByte, 0, responseByte, 0, statusByte.Length);

					await networkSteam.WriteAsync (responseByte, 0, responseByte.Length);

				} else {

					//处理请求
					var response = await requestProcessor.Process(request);

					statusByte = BitConverter.GetBytes((int)response.Status);
					responseByte = new byte[sizeof(int) + response.Data.Length];

					Array.Copy (statusByte, 0, responseByte, 0, statusByte.Length);
					Array.Copy (response.Data, 0, responseByte, sizeof(int), response.Data.Length);

					await networkSteam.WriteAsync (responseByte, 0, responseByte.Length);
				}

			}	

			tcpClient.Close ();
		}
			

		private  bool TryDecodeRequest(byte[] requestData,int validCount, out Request request){

			byte[] lenByte = new byte[sizeof(int)];

			Array.Copy (requestData, 512 - sizeof(int), lenByte, 0, sizeof(int));

			int headStrLen = BitConverter.ToInt32 (lenByte, 0);
			string headStr = Encoding.UTF8.GetString (requestData, 0, headStrLen);

			Uri uri  = new Uri(headStr.TrimEnd ());

			ServicePath servicePath;
			if (!ServicePath.TryParse(uri.LocalPath, out servicePath))
			{
				request = null;
				return false;
			}				

			string scope = string.IsNullOrEmpty(uri.Query)||uri.Query.Length<8?"":uri.Query.Substring(7);
			byte[] data = new byte[validCount - 512];

			if (data.Length > 0)
				Array.Copy (requestData, 512, data, 0, data.Length);

			request = new Request(servicePath, scope, data);

			return true;
		}

		public void Start(int port,int threads){

			if (listener != null)
				throw new InvalidOperationException("Trying to start a receiver that is already running");

			listener = new TcpListener(IPAddress.Any,port);

			listenerThread = new Thread(DoListen);
			listenerThread.Start();

		}

		public void Stop(){

			stopFlag = true;

		}
	}
}

