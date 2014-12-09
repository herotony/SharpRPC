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
			//类似KeyValuePair<string,Student>中的string or Student
			if (type.IsGenericParameter)
				return genericArgumentMap[type.Name];

			//类似KeyValuePair<Tkey,TValue>中的TKey or TValue只要一个是泛型T都为true
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
	}
}

