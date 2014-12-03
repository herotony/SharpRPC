using System;
using System.Linq;
using System.Collections.Generic;
using System.Reflection;
using System.Reflection.Emit;
using System.Runtime.Serialization;

namespace ParseConsole
{
	//针对Type类添加的一些扩展功能的方法
	public static class ExtensionType
	{
		//提取远程服务名称，固定以I开始的接口名称，比如：ISomeService，则为SomeService
		public static string GetServiceName(this Type serviceInterface)
		{
			return serviceInterface.Name.Substring(1);
		}

		//用否存在System.Runtime.Serializable的DataContract属性自定义声明，待定
		public static bool IsDataContract(this Type type)
		{
			return type.GetCustomAttributes<DataContractAttribute>().Any();
		}

		//提取所有自定义声明属性的属性成员或者实例,待定
		public static IEnumerable<PropertyInfo> EnumerateDataMembers(this Type type)
		{
			return type.GetProperties(BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic)
				.Where(x => x.GetCustomAttributes(typeof(DataMemberAttribute), true).Any());
		}

		public static Type DeepSubstituteGenerics(this Type type, IReadOnlyDictionary<string, Type> genericArgumentMap)
		{
			if (type.IsGenericParameter)
				return genericArgumentMap[type.Name];
			if (type.IsGenericType)
				return type.GetGenericTypeDefinition().MakeGenericType(type.GetGenericArguments().Select(x => DeepSubstituteGenerics(x, genericArgumentMap)).ToArray());
			if (type.HasElementType)
				return DeepSubstituteGenerics(type.GetElementType(), genericArgumentMap).MakeArrayType();
			return type;
		}

		//是否包含泛型T
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

		//获取type指定方法名的方法
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

		//获取
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

		//获取构造函数
		public static ConstructorInfo GetConstructorSmart(this Type type, Type[] parameterTypes)
		{
			if (type.IsGenericType && type.ContainsTypeBuilders())
			{
				var genericDefinition = type.GetGenericTypeDefinition();
				var constructorInfo = genericDefinition.GetConstructor(parameterTypes);
				return TypeBuilder.GetConstructor(type, constructorInfo);
			}
			return type.GetConstructor(parameterTypes);
		}

	}
}

