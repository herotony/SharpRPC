using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication2
{
	class Program
	{
		static TcpListener tcpListener = TcpListener.Create(1234);

		static void Main(string[] args)
		{
			tcpListener.Start();

			Accept();
			ConnectAsTcpClient();
			Console.WriteLine ("blabla");
			string again = Console.ReadLine();

			while (again.Equals ("try")) {

				for (int i = 0; i < 3; i++) {

					ConnectAsTcpClient ();
				}


				again = Console.ReadLine ();
			}

			Console.ReadLine ();
		}

		private static async void ConnectAsTcpClient()
		{
			using (var tcpClient = new TcpClient())
			{
				Console.WriteLine("[Client] Connecting to server");
				//await tcpClient.ConnectAsync("127.0.0.1", 1234);

				var task = tcpClient.ConnectAsync("121.0.0.1", 1234);

				task.Wait (10000);
				if (!task.IsCompleted) {
					Console.WriteLine ("timeout");
					throw new TimeoutException ();
				}

				Console.WriteLine("[Client] Connected to server");
				using (var networkStream = tcpClient.GetStream())
				{
					Console.WriteLine("[Client] Writing request {0}", ClientRequestString);
					await networkStream.WriteAsync(ClientRequestBytes, 0, ClientRequestBytes.Length);

					var buffer = new byte[4096];
					var byteCount = await networkStream.ReadAsync(buffer, 0, buffer.Length);
					var response = Encoding.UTF8.GetString(buffer, 0, byteCount);
					Console.WriteLine("[Client] Server response was {0}", response);
				}
			}
		}

		private static readonly string ClientRequestString = "Some HTTP request here";
		private static readonly byte[] ClientRequestBytes = Encoding.UTF8.GetBytes(ClientRequestString);

		private static readonly string ServerResponseString = "<?xml version=\"1.0\" encoding=\"utf-8\"?><document><userkey>key</userkey> <machinemode>1</machinemode><serial>0000</serial><unitname>Device</unitname><version>1</version></document>\n";
		private static readonly byte[] ServerResponseBytes = Encoding.UTF8.GetBytes(ServerResponseString);


		private static async void Accept()
		{		
			var tcpClient = await tcpListener.AcceptTcpClientAsync();

			//启动下次监听
			Accept ();

			Console.WriteLine("[Server] Client has connected");
			using (var networkStream = tcpClient.GetStream())
			{

				var buffer = new byte[4096];
				Console.WriteLine("[Server] Reading from client");
				var byteCount = await networkStream.ReadAsync(buffer, 0, buffer.Length);
				var request = Encoding.UTF8.GetString(buffer, 0, byteCount);
				Console.WriteLine("[Server] Client wrote {0}", request);
				await networkStream.WriteAsync(ServerResponseBytes, 0, ServerResponseBytes.Length);
				Console.WriteLine("[Server] Response has been written");
			}
		}
	}
}

