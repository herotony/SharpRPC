using System.Collections.Generic;

namespace Parse.Rpc.StepByStep.Topology
{
	public interface ITopologyParser
	{
		//IReadOnlyDictionary foreach element type is KeyValuePair<string,IServiceToplogy>
		IReadOnlyDictionary<string,IServiceTopology> Parse(string param);
	}
}

