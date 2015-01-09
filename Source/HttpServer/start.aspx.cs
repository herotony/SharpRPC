using System;
using System.Web;
using System.Web.UI;
using System.Text;
using IHttpFunction;

using SharpRpc;
using SharpRpc.Topology;

namespace HttpServer
{
	
	public partial class start : System.Web.UI.Page
	{
		protected void Page_Load(object sender,EventArgs e){

			var topologyLoader = new TopologyLoader(AppDomain.CurrentDomain.BaseDirectory+"topology.txt", Encoding.UTF8, new TopologyParser());
			var client = new RpcClient(topologyLoader, new TimeoutSettings(500));

			IProcessHttpRequest request1 = client.GetService<IProcessHttpRequest>();
			ResponseInfo resp = request1.VisitServer("login","sid","1.2001",new string[]{"测试id","测试id2"});

			Response.Write (AppDomain.CurrentDomain.BaseDirectory);
			Response.Write (string.Format("status:{0} receive:{1} response:{2} consume:{3} message:{4}",resp.IsOk,resp.ServerReceiveTime,resp.ServerResponseTime,resp.MillionSecondesOfServerProcess,resp.MessageBody));

		}
	}
}

