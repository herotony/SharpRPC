using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Reflection.Emit;
using System.Runtime.Serialization;

namespace Parse.Rpc.StepByStep.Reflection
{
	public static class TypeExtensions
	{
		//提取远程服务名称，固定以I开始的接口名称，比如：ISomeService，则为SomeService
		public static string GetServiceName(this Type serviceInterface)
		{
			return serviceInterface.Name.Substring(1);
		}

		//需要专门测试一下
		public static Type DeepSubstituteGenerics(this Type type, IReadOnlyDictionary<string, Type> genericArgumentMap)
		{

			if (type.IsGenericParameter)
				return genericArgumentMap[type.Name];


			if (type.IsGenericType)
				return type.GetGenericTypeDefinition().MakeGenericType(type.GetGenericArguments().Select(x => DeepSubstituteGenerics(x, genericArgumentMap)).ToArray());

			//代表当前type是数组，指针或者ref type
			//type.GetElementType()，专门用于提取返回数组，指针，ref 所包含，指向或引用的type类型
			//type.MakeArrayTpe返回类似int[]的一维数组的type
			if (type.HasElementType)
				return DeepSubstituteGenerics(type.GetElementType(), genericArgumentMap).MakeArrayType();

			//非泛型直接返回即可，所以输入参数genericArgumentMap只对泛型才有参考价值
			return type;
		}

		public static MethodInfo GetMethodSmart(this Type type, string methodName)
		{
			if (type.IsGenericType && type.ContainsTypeBuilders())
			{
				var genericDefinition = type.GetGenericTypeDefinition();
				var methodInfo = genericDefinition.GetMethod(methodName);
				return TypeBuilder.GetMethod(type, methodInfo);
			}
			return type.GetMethod(methodName);
		}

		public static MethodInfo GetMethodSmart(this Type type, Func<MethodInfo, bool> isCorrectMethod)
		{
			if (type.IsGenericType && type.ContainsTypeBuilders())
			{
				var genericDefinition = type.GetGenericTypeDefinition();
				var methodInfo = genericDefinition.GetMethods().Single(isCorrectMethod);
				return TypeBuilder.GetMethod(type, methodInfo);
			}
			return type.GetMethods().Single(isCorrectMethod);
		}

		public static bool ContainsTypeBuilders(this Type type)
		{
			if (type is GenericTypeParameterBuilder)
				return true;
			if (type.IsGenericType)
				return type.GenericTypeArguments.Any(ContainsTypeBuilders);
			if (type.HasElementType)
				return ContainsTypeBuilders(type.GetElementType());
			return false;
		}
	}
}

