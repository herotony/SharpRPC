using System;
using System.Reflection;

namespace Parse.Rpc.StepByStep.Codecs
{
	public static class TypeMethods
	{
		public static MethodInfo GetTypeFromHandle { get; private set; }

		static TypeMethods()
		{
			GetTypeFromHandle = typeof(Type).GetMethod("GetTypeFromHandle");
		}
	}
}

