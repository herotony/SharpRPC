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

		private const int NoTimeout = -1;

		public async Task<Response> SendAsync(string host, int port, Request request, int? timeoutMilliseconds){

			int timeout = timeoutMilliseconds ?? NoTimeout;

			var tcpClient = new TcpClient ();

			await tcpClient.ConnectAsync (host, port);

			byte[] result = new byte[0];
			ResponseStatus status = ResponseStatus.Ok;

			using (var networkStream = tcpClient.GetStream ()) {

				networkStream.WriteTimeout = timeout;
				networkStream.ReadTimeout = timeout;

				var uri = string.Format("tcp://{0}:{1}/{2}?scope={3}", host, port, request.Path, request.ServiceScope); 

				byte[] uriByte = Encoding.UTF8.GetBytes (uri);
				byte[] lenInfoByte = BitConverter.GetBytes(uriByte.Length);

				byte[] transfer = new byte[512+request.Data.Length];

				Array.Copy (uriByte, 0, transfer, 0, uriByte.Length);
				Array.Copy (lenInfoByte, 0, transfer, 512 - sizeof(int), lenInfoByte.Length);

				if(request.Data.Length>0)
					Array.Copy (request.Data, 0, transfer, 512, request.Data.Length);
								
				await networkStream.WriteAsync (transfer, 0, transfer.Length);

				//一次请求返回数据超过1兆就TM该毙掉
				var buff = new byte[1024*1024];

				var byteCount = await networkStream.ReadAsync (buff, 0, buff.Length);

				if (byteCount < sizeof(int)) {

					return new Response (ResponseStatus.Exception, new byte[0]);
				}

				int realDataLength = byteCount - sizeof(int);

				result = new byte[realDataLength];

				if(realDataLength>0)
					Array.Copy (buff, sizeof(int), result, 0, realDataLength);		

				byte[] statusByte = new byte[sizeof(int)];

				Array.Copy (buff, 0, statusByte,0, sizeof(int));

				status = (ResponseStatus)BitConverter.ToInt32(statusByte,0);
			}				

			tcpClient.Client.Close ();

			return new Response (status, result);
		}	

		public async Task<Response> SendAsync1(string host, int port, Request request, int? timeoutMilliseconds){


			return null;
		}
			
	}
}

