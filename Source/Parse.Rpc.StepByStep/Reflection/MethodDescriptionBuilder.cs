using System;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;

namespace Parse.Rpc.StepByStep.Reflection
{
	public class MethodDescriptionBuilder :IMethodDescriptionBuilder
	{
		public MethodDescription Build(MethodInfo methodInfo)
		{
			var remotingType = GetRemotingType(methodInfo.ReturnType);

			var parameters = methodInfo.GetParameters().Select(BuildParameterDescription).ToArray();

			var genericParameters = methodInfo.IsGenericMethod
				? methodInfo.GetGenericArguments().Select(BuildGenericParameterDescription).ToArray()
				: new GenericParameterDescription[0];

			return new MethodDescription
			{
				RemotingType = GetRemotingType(methodInfo.ReturnType),
				MethodInfo = methodInfo,
				ReturnType = methodInfo.ReturnType,
				Name = methodInfo.Name,
				Parameters = parameters,
				GenericParameters = genericParameters
			};
		}

		private static MethodRemotingType GetRemotingType(Type returnType)
		{
			if (returnType == typeof(Task))
				return MethodRemotingType.AsyncVoid;

			if (returnType.IsGenericType && returnType.GetGenericTypeDefinition() == typeof(Task<>))
				return MethodRemotingType.AsyncWithRetval;

			return MethodRemotingType.Direct;
		}

		private static MethodParameterWay GetWay(ParameterInfo parameterInfo)
		{
			if (parameterInfo.IsOut)
				return MethodParameterWay.Out;

			if (parameterInfo.ParameterType.IsByRef)
				return MethodParameterWay.Ref;

			return MethodParameterWay.Val;
		}

		private static GenericParameterDescription BuildGenericParameterDescription(Type type)
		{
			return new GenericParameterDescription(type.Name);
		}

		private static MethodParameterDescription BuildParameterDescription(ParameterInfo parameterInfo, int index)
		{
			var way = GetWay(parameterInfo);

			var parameterType = way == MethodParameterWay.Val 
				? parameterInfo.ParameterType
				: parameterInfo.ParameterType.GetElementType();//数组或者ref或者指针参数，通过该方法才能提取到正确的type

			return new MethodParameterDescription(index, parameterType, parameterInfo.Name, way);
		}
	}
}

