using System;
using System.Reflection.Emit;

namespace Parse.Rpc.StepByStep.Codecs
{
	//将方法的实际输入参数载入到指定的堆栈上。
	public static class Loaders
	{
		public static Action<MyILGenerator> Argument(int index)
		{
			return il => il.Ldarg(index);
		}

		public static Action<MyILGenerator> ArgumentRef(int index, Type type)
		{
			return il =>
			{
				il.Ldarg(index);
				il.Ldobj(type);
			};
		}

		public static Action<MyILGenerator> Local(LocalBuilder local)
		{
			return il => il.Ldloc(local);
		}

		public static Action<MyILGenerator> TypeOf(Type type)
		{
			return il =>
			{
				il.Ldtoken(type);
				il.Call(TypeMethods.GetTypeFromHandle);
			};
		}
	}
}

