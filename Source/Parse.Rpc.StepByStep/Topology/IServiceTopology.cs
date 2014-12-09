using System.Collections.Generic;

namespace Parse.Rpc.StepByStep.Topology
{
	public interface IServiceTopology
	{
		IEnumerable<ServiceEndPoint> GetAllKnownEndPoints(); 

		//scope必须是合法的格式：protocol://host:port
		bool TryGetEndPoint(string scope, out ServiceEndPoint endPoint); 
	}
}

