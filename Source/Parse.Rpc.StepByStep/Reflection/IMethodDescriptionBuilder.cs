using System.Reflection;

namespace Parse.Rpc.StepByStep.Reflection
{
	public interface IMethodDescriptionBuilder
	{
		MethodDescription Build(MethodInfo methodInfo);
	}
}

