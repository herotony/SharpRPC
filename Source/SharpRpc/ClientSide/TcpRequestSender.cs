using System;
using System.Text;
using System.Collections.Concurrent;
using System.Net.Sockets;
using System.Threading.Tasks;
using SharpRpc.Interaction;

namespace SharpRpc.ClientSide
{
	public class TcpRequestSender : IRequestSender
	{
		private readonly ConcurrentDictionary<int, Lazy<TcpClient>> tcpClients;

		public TcpRequestSender ()
		{
			tcpClients = new ConcurrentDictionary<int, Lazy<TcpClient>> ();
		}

		private const int NoTimeout = -1;

		public async Task<Response> SendAsync(string host, int port, Request request, int? timeoutMilliseconds){

			int timeout = timeoutMilliseconds ?? NoTimeout;

			var tcpClient = tcpClients.GetOrAdd (timeoutMilliseconds ?? NoTimeout, CreateLazyTcpClient).Value;

			await tcpClient.ConnectAsync (host, port);

			byte[] result = new byte[0];
			ResponseStatus status = ResponseStatus.Ok;

			using (var networkStream = tcpClient.GetStream ()) {

				networkStream.WriteTimeout = timeout;
				networkStream.ReadTimeout = timeout;

				var uri = string.Format("tcp://{0}:{1}/{2}?scope={3}", host, port, request.Path, request.ServiceScope); 

				byte[] uriByte = Encoding.UTF8.GetBytes (uri);
				byte[] transfer = new byte[512+request.Data.Length];

				Array.Copy (uriByte, 0, transfer, 0, uriByte.Length);

				if(request.Data.Length>0)
					Array.Copy (request.Data, 0, transfer, 512, request.Data.Length);
								
				await networkStream.WriteAsync (transfer, 0, transfer.Length);

				//一次请求超过1兆就TM该毙掉
				var buff = new byte[1024*1024];

				var byteCount = await networkStream.ReadAsync (buff, 0, buff.Length);

				result = new byte[byteCount-4];

				int realDataLength = byteCount - 4;

				if(realDataLength>0)
					Array.Copy (buff, 4, result, 0, realDataLength);		

				string statusInfo = Encoding.UTF8.GetString (buff, 0, 4);
				status = (ResponseStatus)int.Parse (statusInfo);
			}				

			return new Response (status, result);
		}

		private static Lazy<TcpClient> CreateLazyTcpClient(int timeoutMilliseconds)
		{
			return new Lazy<TcpClient>(() => {return new TcpClient();});
		} 
			
	}
}

