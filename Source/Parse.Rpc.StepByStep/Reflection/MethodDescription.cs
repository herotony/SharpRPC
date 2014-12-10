using System;
using System.Collections.Generic;
using System.Reflection;

namespace Parse.Rpc.StepByStep.Reflection
{
	public class MethodDescription
	{
		public MethodRemotingType RemotingType { get; set; }
		public MethodInfo MethodInfo { get; set; }
		public Type ReturnType { get; set; }
		public string Name { get; set; }
		public IReadOnlyList<GenericParameterDescription> GenericParameters { get; set; }
		public IReadOnlyList<MethodParameterDescription> Parameters { get; set; }
	}
}

