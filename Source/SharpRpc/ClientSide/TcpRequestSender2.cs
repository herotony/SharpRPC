using System;
using System.Text;
using System.Threading.Tasks;
using SharpRpc.Interaction;

using AsyncSocketLibrary.Common.Client;

namespace SharpRpc.ClientSide
{
	public class TcpRequestSender2 : IRequestSender
	{
		public TcpRequestSender2(){

			this.Protocol = "tcp";
		}
		public string Protocol{ get; private set;}

		public Response Send(string host, int port, Request request, int? timeoutMilliseconds){

			var uri = string.Format("tcp://{0}:{1}/{2}?scope={3}", host, port, request.Path, request.ServiceScope); 
			byte[] uriByte = Encoding.UTF8.GetBytes (uri);
			byte[] headLenByte = BitConverter.GetBytes (uriByte.Length);
			byte[] sendData = new byte[headLenByte.Length + uriByte.Length + request.Data.Length];

			Array.Copy (headLenByte, 0, sendData, 0, headLenByte.Length);
			Array.Copy (uriByte, 0, sendData, headLenByte.Length, uriByte.Length);
			Array.Copy (request.Data,0, sendData, headLenByte.Length + uriByte.Length, request.Data.Length);

			string logInfo = string.Empty;
			byte[] result = SocketClient.PushSendDataToPool (sendData, ref logInfo);

			if (result == null)
				return new Response (ResponseStatus.Exception, new byte[0]);

			int TransServerId = BitConverter.ToInt32 (result, 0);
			ResponseStatus responseStatusValue = (ResponseStatus)BitConverter.ToInt32 (result, 4);

			if (responseStatusValue == ResponseStatus.BadRequest)
				return new Response (ResponseStatus.BadRequest, new byte[0]);

			byte[] data = new byte[result.Length - 8];
			Array.Copy (result, 8, data, 0, result.Length - 8);

			return new Response(responseStatusValue,data);
		}

		public Task<Response> SendAsync(string host, int port, Request request, int? timeoutMilliseconds){

			return null;
		}
	}
}

