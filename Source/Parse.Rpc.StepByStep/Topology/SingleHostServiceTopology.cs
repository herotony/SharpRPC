using System;
using System.Collections.Generic;

namespace Parse.Rpc.StepByStep.Topology
{
	public class SingleHostServiceTopology :IServiceTopology
	{
		private readonly ServiceEndPoint endPoint;

		public SingleHostServiceTopology (ServiceEndPoint endPoint)
		{
			this.endPoint = endPoint;
		}

		public IEnumerable<ServiceEndPoint> GetAllKnownEndPoints()
		{
			//yield return 相当于返回IEnumrable集合，该集合目前只包含一个元素endPoint
			yield return endPoint;
		}

		//  tcp://inner_domain.com:60  scope参数此处完全无意义
		public bool TryGetEndPoint(string scope, out ServiceEndPoint endPoint)
		{
			endPoint = this.endPoint;
			return true;
		}
	}
}

