using System;

namespace Parse.Rpc.StepByStep.ClientSide.Proxy
{
	public interface IProxyFactory
	{
		Func<IOutgoingRequestProcessor, string, TimeoutSettings, T> CreateProxy<T>();
	}
}

