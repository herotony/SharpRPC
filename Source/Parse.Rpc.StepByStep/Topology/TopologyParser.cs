using System;
using System.Linq;
using System.IO;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Parse.Rpc.StepByStep.Topology
{
	public class TopologyParser : ITopologyParser
	{
		private static readonly char[] LineBreaks = new[] { '\r', '\n' };
		private static readonly char[] Comma = new [] {','};

		//serviceName topologyType [endPointsText：多个端点集合]
		private static readonly Regex ServiceTopologyRegex = new Regex(@"^(\w+)\s+(\w+)(\s+([^\s].*))?$");

		//[@]word anysentence
		private static readonly Regex MapElementRegex = new Regex(@"^([\@\w]+)\s+([^\s]+)$");

		public IReadOnlyDictionary<string, IServiceTopology> Parse(string param)
		{
			var lines = param.Split(LineBreaks, StringSplitOptions.RemoveEmptyEntries);
			return lines.Select(ParseServiceNameAndTopology).ToDictionary(x => x.Key, x => x.Value);
		}

		private static KeyValuePair<string, IServiceTopology> ParseServiceNameAndTopology(string line)
		{
			var match = ServiceTopologyRegex.Match(line.Trim());

			if (!match.Success)
				throw new InvalidDataException(string.Format("'{0}' is not a valid service topology description", line));

			var serviceName = match.Groups[1].Value;
			var serviceTopologyType = match.Groups[2].Value;
			var endPointsText = match.Groups[4].Value;

			IServiceTopology serviceTopology;
			switch (serviceTopologyType)
			{
				case "single": serviceTopology = ParseSingleServiceTopology(endPointsText); break;			
				case "random": serviceTopology = ParseRandomServiceTopology(endPointsText); break;						
				default: throw new InvalidDataException(string.Format("Unknown service topology type '{0}'", serviceTopologyType));
			}

			return new KeyValuePair<string, IServiceTopology>(serviceName, serviceTopology);
		}

		private static IServiceTopology ParseSingleServiceTopology(string endPointsText)
		{
			//return new SingleHostServiceTopology(ServiceEndPoint.Parse(endPointsText.Trim()));
			return null;
		}

		private static IServiceTopology ParseRandomServiceTopology(string endPointsText)
		{
			//serviceName random tcp://inner_domainanme.com:20,tcp://inner_domainname.com:60,...
			return new RandomServiceTopology(endPointsText.Split(Comma, StringSplitOptions.RemoveEmptyEntries).Select(x => ServiceEndPoint.Parse(x.Trim())));
		}
	}
}

