using System;
using System.Collections.Generic;

using Sharp.Rpc.CommonObject;

namespace SharpRpc.ProxyMyService
{
	public interface IComplexService
	{
		byte[] GetStudentList(byte[] input);
		JsonStruct GetXmlOrJsonString(string protocol,string sid,string pid,double lon,double lat,string[] paramStr);
	}


}

