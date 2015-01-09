using System;
using System.Text;
using System.Diagnostics;
using SharpRpc.ProxyMyService;
using Sharp.Rpc.CommonObject;
using SharpRpc.Topology;

using log4net;

namespace SharpRpc.TestClient
{
	public class TestComplexIII
	{
		private static ILog logProgram = LogManager.GetLogger (typeof(TestComplexIII));

		public TestComplexIII ()
		{
		}

		public void Run(){


			var topologyLoader = new TopologyLoader("../Topology/topology.txt", Encoding.UTF8, new TopologyParser());
			var client = new RpcClient(topologyLoader, new TimeoutSettings(500));

			Stopwatch sw = new Stopwatch ();

			Stopwatch swTotal = new Stopwatch ();

			swTotal.Start ();

			for (int i = 0; i < 10; i++) {

				sw.Start ();

				var complexService = client.GetService<IComplexService> ();

				JsonStruct result = complexService.GetXmlOrJsonString ("phoneloginwowo", "sessionid-home", "1.4001", 123.000, 80.100, new string[] {
					"help",
					"sos"
				});

				logProgram.InfoFormat ("====总耗时:{0} ms====",sw.ElapsedMilliseconds);

				sw.Reset ();

				logProgram.InfoFormat ("name:{0}", result.Name);
				logProgram.InfoFormat ("reminder:{0}", result.Reminder);

				if (result.JsonStr != null && result.JsonStr.Length > 0)
					foreach (string value in result.JsonStr)
						logProgram.InfoFormat ("json:{0}", value);

			}

			logProgram.WarnFormat ("总共耗时:{0} ms", swTotal.ElapsedMilliseconds);

					

		}
	}
}

