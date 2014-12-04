using System;
using System.Collections.Generic;

using Google.ProtoBuf;

namespace Sharp.Rpc.CommonObject
{
	[ProtoContract]
	public class Student
	{
		[ProtoMember(1)]
		public string Name{ get; set;}
		[ProtoMember(2)]
		public int Age{ get; set;}
		[ProtoMember(3)]
		public int Score{ get; set;}
		[ProtoMember(4)]
		public bool Male{ get; set;}
		[ProtoMember(5)]
		public List<string> Address{ get; set;}

		public override string ToString ()
		{
			return string.Format ("[Student: Name={0}, Age={1}, Score={2},Male={3}]", Name, Age, Score,Male);
		}
	}
}

