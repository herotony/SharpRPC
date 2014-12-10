using System;
using System.Collections.Generic;

namespace Parse.Rpc.StepByStep.Reflection
{
	public class ServiceDescription
	{
		public Type Type { get; set; }
		public string Name { get; set; }
		public IReadOnlyList<ServiceDescription> Subservices { get; set; }
		public IReadOnlyList<MethodDescription> Methods { get; set; }
	}
}

