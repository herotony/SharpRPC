using System;

namespace SharpRpc.ServerSide.SocketServer
{
	public interface ILogicServer
	{
		string GetResponse(string request);
	}
}

