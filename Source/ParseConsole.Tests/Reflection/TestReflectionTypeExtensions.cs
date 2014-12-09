using System;

using System.Collections.Generic;
using System.Linq;
using NUnit.Framework;
using NSubstitute;
using System.Runtime.Serialization;
using Parse.Rpc.StepByStep.Reflection;

namespace ParseConsole.Tests
{
	[TestFixture]
	public class TestReflectionTypeExtensions
	{
		#region 测试DeepSubstitudeGenerics

		[Test]
		public void TestDeepSubstituteGenerics(){

			Type t = typeof(IReadOnlyDictionary<string,Student>);

			IReadOnlyDictionary<string,Type> d = InitSample ();

			Type x = t.DeepSubstituteGenerics (d);

			Assert.AreEqual (x.Name, t.Name);
			Assert.AreSame (x, t);
		}

		private IReadOnlyDictionary<string,Type> InitSample(){

			string name = typeof(Student).Name;
			Type t = typeof(Student);

			List<KeyValuePair<string,Type>> lst = new List<KeyValuePair<string, Type>> ();
			KeyValuePair<string,Type> kv = new KeyValuePair<string, Type> (name, t);
			KeyValuePair<string,Type> kv1 = new KeyValuePair<string, Type> (typeof(int).Name, typeof(int));

			lst.Add (kv);
			lst.Add (kv1);

			IReadOnlyDictionary<string,Type> d = lst.ToDictionary (x=>x.Key,x=>x.Value);

			return d;
		}

		#endregion

	}

	[Serializable]
	public class Student{

		public string Name{ get; set;}
		public int Aget{ get; set;}
		public string Address{ get; set;}
		public bool Male{ get; set;}
	}
}

