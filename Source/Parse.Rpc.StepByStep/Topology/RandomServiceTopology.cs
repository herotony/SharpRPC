using System;
using System.Collections.Generic;
using System.Linq;

namespace Parse.Rpc.StepByStep.Topology
{
	public class RandomServiceTopology:IServiceTopology
	{
		//转为数组就是为了random来随机提取索引
		private readonly ServiceEndPoint[] endPoints;
		private readonly Random random = new Random();

		public RandomServiceTopology (params ServiceEndPoint[] endPoints):this(endPoints as IEnumerable<ServiceEndPoint>){
		}

		public RandomServiceTopology(IEnumerable<ServiceEndPoint> endPoints)
		{
			if (endPoints == null)
				throw new ArgumentNullException("endPoints");

			this.endPoints = endPoints.ToArray();

			if (this.endPoints.Length == 0)
				throw new ArgumentException("End point collection must have at least one element", "endPoints");
		}

		public IEnumerable<ServiceEndPoint> GetAllKnownEndPoints()
		{
			return endPoints;
		}

		//scope参数此处完全无意义
		public bool TryGetEndPoint(string scope, out ServiceEndPoint endPoint)
		{
			int index = random.Next(0, endPoints.Length);
			endPoint = endPoints[index];
			return true;
		}
	}
}

