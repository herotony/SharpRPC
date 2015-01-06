using System;
using System.Net;
using System.Net.Sockets;
using System.Threading.Tasks;

using SharpRpc.Interaction;
using SharpRpc.ClientSide;

namespace TcpManager
{
	public class TcpRequestSender :IRequestSender
	{
		public TcpRequestSender ()
		{

		}

		public async Task<Response> SendAsync(string host,int port,Request request,int? timeoutMilliseconds){



			return null;

		}
	}
}

