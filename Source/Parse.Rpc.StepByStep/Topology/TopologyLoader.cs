using System.Collections.Generic;
using System.IO;
using System.Text;

namespace Parse.Rpc.StepByStep.Topology
{
	public class TopologyLoader
	{
		private readonly string topologyPath;
		private readonly Encoding encoding;
		private readonly ITopologyParser topologyParser;

		public TopologyLoader(string topologyPath, Encoding encoding, ITopologyParser topologyParser)
		{
			this.topologyPath = topologyPath;
			this.encoding = encoding;
			this.topologyParser = topologyParser;
		}

		public IReadOnlyDictionary<string, IServiceTopology> Load()
		{
			var text = File.ReadAllText(topologyPath, encoding);
			return topologyParser.Parse(text);
		}
	}
}

