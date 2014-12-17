using System;
using System.Collections.Generic;
using System.Linq;
using NUnit.Framework;
using NSubstitute;
using System.Reflection;
using System.Reflection.Emit;
using System.Runtime.Serialization;


using Parse.Rpc.StepByStep.Codecs;
using Parse.Rpc.StepByStep.Reflection;
using Parse.Rpc.StepByStep.ClientSide.Proxy;

namespace ParseConsole.Tests
{
	[TestFixture]
	public class TestReflectionTypeExtensions
	{
		#region 测试DeepSubstitudeGenerics

		//[Test]
		public void TestDeepSubstituteGenerics(){

			Type t = typeof(IReadOnlyDictionary<string,Student>);

			bool h = t.IsGenericType;

			h = t.IsGenericParameter;

			IReadOnlyDictionary<string,Type> d = InitSample ();

			h = d.GetType ().IsGenericParameter;
			h = d.GetType ().IsGenericType;


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

        #region 测试ServiceDescriptionBuiler

		//[Test]
		public void TestServiceDescriptionBuilder(){

			var builder = new ServiceDescriptionBuilder (new MethodDescriptionBuilder ());

			ServiceDescription sd = builder.Build (typeof(IProxyFactory));

			sd = builder.Build (typeof(ISecondComplexEx));

			foreach (var method in sd.Methods) {

				string name = method.Name;
				Type k = method.ReturnType;
				MethodRemotingType t = method.RemotingType;

				foreach (var param in method.Parameters) {

					string n = param.Name;
					Type ttt = param.Type;
					int index = param.Index;
					MethodParameterWay x =   param.Way;
				}

			}				

			Assert.AreEqual (1, 1);

		}


		#endregion

		#region 测试Ldarg,Ldobj

		[Test]
		public void TestLdarg(){

			var appDomain = AppDomain.CurrentDomain;
			var assemblyBuilder = appDomain.DefineDynamicAssembly(new AssemblyName("rkProxies"), AssemblyBuilderAccess.Run);
			var moduleBuilder = assemblyBuilder.DefineDynamicModule("rkProxyModule");
			var typeBuilder = moduleBuilder.DefineType ("rkComplex", TypeAttributes.Public | TypeAttributes.Sealed | TypeAttributes.Class, typeof(object), new[] { typeof(IComplexEx) });

			var methodBuilder = typeBuilder.DefineMethod("GetStudent",MethodAttributes.Public | MethodAttributes.Final | MethodAttributes.HideBySig |
			MethodAttributes.NewSlot | MethodAttributes.Virtual);


			methodBuilder.SetParameters (new Type[]{ typeof(Student) });
			methodBuilder.SetReturnType (typeof(string));
			methodBuilder.SetImplementationFlags(MethodImplAttributes.Managed);

			ILGenerator il = methodBuilder.GetILGenerator ();




			var param = methodBuilder.GetParameters() [0];
			var local = il.DeclareLocal (param.ParameterType, true);//声明一个类型为Student的本地变量
			var retstr = il.DeclareLocal (typeof(string), true);

			il.Emit (OpCodes.Ldarg_0);

			if (param.ParameterType.IsValueType)
				il.Emit (OpCodes.Unbox_Any, param.ParameterType); //值类型，拆箱操作:string=(string)object;
			else
				il.Emit (OpCodes.Castclass, param.ParameterType); //引用类型，class=(class)object;

			il.Emit (OpCodes.Stloc, local);//将上面装箱或者转换赋值到本地变量

			var toStrMethod = typeof(Student).GetMethod ("ToString");
			il.Emit (OpCodes.Callvirt, toStrMethod);
			il.Emit (OpCodes.Ldloca, retstr);

			il.Emit (OpCodes.Ret);
				
			typeBuilder.DefineDefaultConstructor(MethodAttributes.Public | MethodAttributes.HideBySig | MethodAttributes.SpecialName | MethodAttributes.RTSpecialName);
			Type finalType = typeBuilder.CreateType ();

			IComplexEx  instance = (IComplexEx)Activator.CreateInstance (finalType);

		
			Student st1 = new Student ();

			st1.Address="北京";
			st1.Age = 30;
			st1.Male = false;
			st1.Name = "H";

			string ret = instance.GetStudent (st1);
				
			Assert.AreEqual (1, 1);
		}

		#endregion

		#region 随意测

		//[Test]
		public void TestAnyWay(){

			string[] arr = new string[]{ "one moment","测试开始","正式发布!","联调结束!"};

			var result = arr.Select (CheckIt).ToArray ();

			foreach (var k in result)
				Console.WriteLine (k);

			var result1 = GetAllInterfaces (typeof(Dictionary<int,string>)).Distinct().ToArray();
			var properties = result1.SelectMany(x => x.GetProperties()).ToArray();

			foreach (var k in result1)
				Console.WriteLine (k);

			foreach (var k in properties)
				Console.WriteLine (k);

			Assert.AreEqual (1, 1);

		}

		private static string CheckIt(string input,int index){

			return string.Format ("{0}:{1}", index, input);
		}

		private static IEnumerable<Type> GetAllInterfaces(Type baseInterface)
		{
			yield return baseInterface;

			foreach (var subInterface in baseInterface.GetInterfaces())
				foreach (var subsubinterface in GetAllInterfaces(subInterface))
					yield return subsubinterface;
		} 

		#endregion

	}

	#region 测试模拟数据

	public interface IComplexEx{
	
		//Student GetSutdent<T>(int i,decimal[] d,string k,string[] h,DateTime dt,List<Student> lst,KeyValuePair<string,Student> kv,ref string error,out Student exp);
		string GetStudent (Student st);
	}

	public interface ISecondComplexEx :IComplexEx{

		//string Name{ get; set;}
		string Name{ get; }

		List<Student> GetAllStudent (string school, ref string errorMessage);
	}

	[Serializable]
	public class Student{

		public string Name{ get; set;}
		public int Age{ get; set;}
		public string Address{ get; set;}
		public bool Male{ get; set;}

		public override string ToString ()
		{
			return string.Format ("[Student: Name={0}, Age={1}, Address={2}, Male={3}]", Name, Age, Address, Male);
		}
	}

	#endregion
}

