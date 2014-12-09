using System.Collections.Generic;

namespace Parse.Rpc.StepByStep.Topology
{
	public interface ITopologyLoader
	{
		IReadOnlyDictionary<string,IServiceTopology> Load();
	}
}

