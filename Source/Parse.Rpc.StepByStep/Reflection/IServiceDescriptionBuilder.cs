using System;

namespace Parse.Rpc.StepByStep.Reflection
{
	public interface IServiceDescriptionBuilder
	{
		ServiceDescription Build(Type interfaceType);
	}
}

