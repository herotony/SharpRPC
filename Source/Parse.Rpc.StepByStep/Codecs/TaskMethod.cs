using System;
using System.Reflection;
using System.Threading.Tasks;
using Parse.Rpc.StepByStep.Reflection;

namespace Parse.Rpc.StepByStep.Codecs
{
	public static class TaskMethods
	{
		public static MethodInfo GetResult(Type resultType) { return typeof(Task<>).MakeGenericType(resultType).GetMethodSmart("get_Result"); }
		public static MethodInfo FromResult(Type resultType) { return typeof(Task).GetMethod("FromResult").MakeGenericMethod(resultType); }

		public static MethodInfo ContinueWith(Type originalResultType, Type continuationResultType)
		{
			return typeof(Task<>).MakeGenericType(originalResultType).GetMethodSmart(IsCorrectContinueWith).MakeGenericMethod(continuationResultType);
		}

		private static bool IsCorrectContinueWith(MethodInfo methodInfo)
		{
			if (methodInfo.Name != "ContinueWith")
				return false;

			var parameters = methodInfo.GetParameters();
			if (parameters.Length != 1)
				return false;

			var parameterType = parameters[0].ParameterType;
			if (parameterType.GetGenericTypeDefinition() != typeof(Func<,>))
				return false;

			if (!parameterType.GetGenericArguments()[0].IsGenericType)
				return false;

			return true;
		}
	}
}

