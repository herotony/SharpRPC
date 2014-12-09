using System;

namespace Parse.Rpc.StepByStep.ClientSide.Proxy
{
	public interface IProxyContainer
	{
		T GetProxy<T> (string scope, TimeoutSettings timeOutSettings) where T : class;
	}
}

