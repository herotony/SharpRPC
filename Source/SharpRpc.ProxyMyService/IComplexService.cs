using System;
using System.Collections.Generic;

namespace SharpRpc.ProxyMyService
{
	public interface IComplexService
	{
		byte[] GetStudentList(byte[] input);
	}
}

