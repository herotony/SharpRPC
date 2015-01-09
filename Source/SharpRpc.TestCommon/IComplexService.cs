using System;
using System.Collections.Generic;
using Sharp.Rpc.CommonObject;

namespace SharpRpc.TestCommon
{
	public interface IComplexService
	{
		byte[] GetStudentList(byte[] input);
		JsonStruct GetXmlOrJsonString(string protocol,string sid,string pid,double lon,double lat,string[] paramStr);
	}

	public struct JsonStruct{

		public string Name;
		public int Index;
		public DateTime Date;
		public decimal Price;
		public string Reminder;
		public string[] JsonStr;
	}
		
}

