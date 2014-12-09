using System;
using System.Threading.Tasks;

namespace Parse.Rpc.StepByStep.ClientSide
{
	public interface IOutgoingRequestProcessor
	{
		byte[] Process(Type serviceInterface, string pathSeparatedBySlashes, string serviceScope, byte[] data, TimeoutSettings timeoutSettings);
		Task<byte[]> ProcessAsync(Type serviceInterface, string pathSeparatedBySlashes, string serviceScope, byte[] data, TimeoutSettings timeoutSettings);
	}
}

