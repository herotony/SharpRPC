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
		
			Type t1 = typeof(char);

			bool bValue = t1.IsPrimitive;

			bValue = t1.IsValueType;


			var appDomain = AppDomain.CurrentDomain;
			var assemblyBuilder = appDomain.DefineDynamicAssembly(new AssemblyName("rkProxies"), AssemblyBuilderAccess.RunAndSave);
			var moduleBuilder = assemblyBuilder.DefineDynamicModule("rkProxiesModule","rkProxies.dll");
			var typeBuilder = moduleBuilder.DefineType ("rkComplex", TypeAttributes.Public | TypeAttributes.Sealed | TypeAttributes.Class, typeof(object), new Type[]{typeof(IComplexEx)});

			CreateClassForComplex (typeBuilder);

			try{

				var  type1 = typeBuilder.CreateType ();

				assemblyBuilder.SetEntryPoint(type1.GetMethod("GetStudent"));

				assemblyBuilder.Save("rkProxies.dll");

				Student st1 = new Student ();

				st1.Address="北京";
				st1.Age = 30;
				st1.Male = false;
				st1.Name = "H";

				object k = Activator.CreateInstance(type1);

				IComplexEx t = k as IComplexEx;

				string f = t.GetStudent(st1);


			}catch(Exception e){

				string k = e.Message;
			}
												

			Assert.AreEqual (1, 1);
		}

		private static void CreateClassForComplex(TypeBuilder typeBuilder){


			Type objType = Type.GetType("System.Object");
			ConstructorInfo objCtor = objType.GetConstructor(new Type[0]);

			var constructorBuilder = typeBuilder.DefineConstructor(
				MethodAttributes.Public, CallingConventions.Standard,new Type[0]);

			ILGenerator ilOfCtor = constructorBuilder.GetILGenerator();

			ilOfCtor.Emit(OpCodes.Ldarg_0);//this，当前实例引用，一般instance的类，ldarg_0就是this
			ilOfCtor.Emit(OpCodes.Call, objCtor);
			ilOfCtor.Emit (OpCodes.Ret);

			typeBuilder.AddInterfaceImplementation (typeof(IComplexEx));//必须加上这句才能代表实现相关接口...
			var methodInfo = typeof(Student).GetMethod ("ToString");
			var methodBuilder = typeBuilder.DefineMethod ("GetStudent", MethodAttributes.Public | MethodAttributes.Final | MethodAttributes.HideBySig |
				MethodAttributes.NewSlot | MethodAttributes.Virtual, CallingConventions.ExplicitThis | CallingConventions.HasThis,typeof(string), new Type[]{ typeof(Student) });

			ILGenerator ilOfmethod = methodBuilder.GetILGenerator ();

			ilOfmethod.Emit (OpCodes.Ldarg_1);//提取Student参数入栈
			ilOfmethod.Emit (OpCodes.Callvirt, methodInfo);//调用Student.ToString()并将结果入栈
			ilOfmethod.Emit (OpCodes.Ret);//返回栈中结果值

		}




		#endregion

		#region 网上例子

		//[Test]
		public void TestEmitFromNet(){

			// specify a new assembly name
			var assemblyName = new AssemblyName("Pets");

			// create assembly builder
			var assemblyBuilder = AppDomain.CurrentDomain
				.DefineDynamicAssembly(assemblyName, AssemblyBuilderAccess.RunAndSave);

			// create module builder
			var moduleBuilder = assemblyBuilder.DefineDynamicModule("PetsModule", "Pets.dll");

			// create type builder for a class
			var typeBuilder = moduleBuilder.DefineType("Kitty", TypeAttributes.Public);

			// then create whole class structure
			CreateKittyClassStructure(typeBuilder);

			// then create the whole class type
			var classType = typeBuilder.CreateType();

			// save assembly
			assemblyBuilder.Save("Pets.dll");

//			Console.WriteLine("Hi, Dennis, a Pets assembly has been generated for you.");
//			Console.ReadLine();

		}


		private static void CreateKittyClassStructure(TypeBuilder typeBuilder)
		{
			// ---- define fields ----

			var fieldId = typeBuilder.DefineField(
				"_id", typeof(int), FieldAttributes.Private);
			var fieldName = typeBuilder.DefineField(
				"_name", typeof(string), FieldAttributes.Private);

			// ---- define costructors ----

			Type objType = Type.GetType("System.Object");
			ConstructorInfo objCtor = objType.GetConstructor(new Type[0]);

			Type[] constructorArgs = { typeof(int), typeof(string) };

			var constructorBuilder = typeBuilder.DefineConstructor(
				MethodAttributes.Public, CallingConventions.Standard, constructorArgs);
			ILGenerator ilOfCtor = constructorBuilder.GetILGenerator();

			ilOfCtor.Emit(OpCodes.Ldarg_0);
			ilOfCtor.Emit(OpCodes.Call, objCtor);
			ilOfCtor.Emit(OpCodes.Ldarg_0);
			ilOfCtor.Emit(OpCodes.Ldarg_1);
			ilOfCtor.Emit(OpCodes.Stfld, fieldId);
			ilOfCtor.Emit(OpCodes.Ldarg_0);
			ilOfCtor.Emit(OpCodes.Ldarg_2);
			ilOfCtor.Emit(OpCodes.Stfld, fieldName);
			ilOfCtor.Emit(OpCodes.Ret);

			// ---- define properties ----

			var methodGetId = typeBuilder.DefineMethod(
				"GetId", MethodAttributes.Public, typeof(int), null);
			var methodSetId = typeBuilder.DefineMethod(
				"SetId", MethodAttributes.Public, null, new Type[] { typeof(int) });

			var ilOfGetId = methodGetId.GetILGenerator();
			ilOfGetId.Emit(OpCodes.Ldarg_0); // this
			ilOfGetId.Emit(OpCodes.Ldfld, fieldId);
			ilOfGetId.Emit(OpCodes.Ret);

			var ilOfSetId = methodSetId.GetILGenerator();
			ilOfSetId.Emit(OpCodes.Ldarg_0); // this
			ilOfSetId.Emit(OpCodes.Ldarg_1); // the first one in arguments list
			ilOfSetId.Emit(OpCodes.Stfld, fieldId);
			ilOfSetId.Emit(OpCodes.Ret);

			// create Id property
			var propertyId = typeBuilder.DefineProperty(
				"Id", PropertyAttributes.None, typeof(int), null);
			propertyId.SetGetMethod(methodGetId);
			propertyId.SetSetMethod(methodSetId);

			var methodGetName = typeBuilder.DefineMethod(
				"GetName", MethodAttributes.Public, typeof(string), null);
			var methodSetName = typeBuilder.DefineMethod(
				"SetName", MethodAttributes.Public, null, new Type[] { typeof(string) });

			var ilOfGetName = methodGetName.GetILGenerator();
			ilOfGetName.Emit(OpCodes.Ldarg_0); // this
			ilOfGetName.Emit(OpCodes.Ldfld, fieldName);
			ilOfGetName.Emit(OpCodes.Ret);

			var ilOfSetName = methodSetName.GetILGenerator();
			ilOfSetName.Emit(OpCodes.Ldarg_0); // this
			ilOfSetName.Emit(OpCodes.Ldarg_1); // the first one in arguments list
			ilOfSetName.Emit(OpCodes.Stfld, fieldName);
			ilOfSetName.Emit(OpCodes.Ret);

			// create Name property
			var propertyName = typeBuilder.DefineProperty(
				"Name", PropertyAttributes.None, typeof(string), null);
			propertyName.SetGetMethod(methodGetName);
			propertyName.SetSetMethod(methodSetName);

			// ---- define methods ----

			// create ToString() method
			var methodToString = typeBuilder.DefineMethod(
				"ToString",
				MethodAttributes.Virtual | MethodAttributes.Public,
				typeof(string),
				null);

			var ilOfToString = methodToString.GetILGenerator();
			var local = ilOfToString.DeclareLocal(typeof(string)); // create a local variable
			ilOfToString.Emit(OpCodes.Ldstr, "Id:[{0}], Name:[{1}]");
			ilOfToString.Emit(OpCodes.Ldarg_0); // this
			ilOfToString.Emit(OpCodes.Ldfld, fieldId);
			ilOfToString.Emit(OpCodes.Box, typeof(int)); // boxing the value type to object
			ilOfToString.Emit(OpCodes.Ldarg_0); // this
			ilOfToString.Emit(OpCodes.Ldfld, fieldName);
			ilOfToString.Emit(OpCodes.Call,
				typeof(string).GetMethod("Format",
					new Type[] { typeof(string), typeof(object), typeof(object) }));
			ilOfToString.Emit(OpCodes.Stloc, local); // set local variable
			ilOfToString.Emit(OpCodes.Ldloc, local); // load local variable to stack
			ilOfToString.Emit(OpCodes.Ret);
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

