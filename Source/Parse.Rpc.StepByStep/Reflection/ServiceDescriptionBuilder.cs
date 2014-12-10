using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace Parse.Rpc.StepByStep.Reflection
{
	public class ServiceDescriptionBuilder : IServiceDescriptionBuilder
	{
		private readonly IMethodDescriptionBuilder methodDescriptionBuilder;

		public ServiceDescriptionBuilder (IMethodDescriptionBuilder methodDescriptionBuilder)
		{
			this.methodDescriptionBuilder = methodDescriptionBuilder;
		}

		public ServiceDescription Build(Type interfaceType)
		{
			return BuildInternal(interfaceType.GetServiceName(), interfaceType);
		}

		private ServiceDescription BuildInternal(string name, Type interfaceType)
		{
			//前提：我们设定场景一定是个Interface类型，通过递归罗列出该接口里所有的其他引用接口并去重!
			var allInterfaces = GetAllInterfaces(interfaceType).Distinct().ToArray();

			#region 这一段基本不会出现在一般的rpc场景中，很少在接口中定义属性或者其他接口的属性。

			//针对每个Interface接口类型提取其属性
			var properties = allInterfaces.SelectMany(x => x.GetProperties()).ToArray();
			var subinterfaceDescs = new List<ServiceDescription>();

			//接口中定义的属性不能有setter，为啥加这限制？目前不明白，但肯定去掉这个限制也能正常获取ServiceDescription
			//当然，我们绝大部分应用不会闲的在Interface里定义属性，一般只定义方法。
			foreach (var propertyInfo in properties)
			{
				if (propertyInfo.SetMethod != null)
					throw new ArgumentException(string.Format("{0} is not a valid service interface since it has a setter ({1})", interfaceType.Name, propertyInfo.Name));

				//递归提取隐含的其他属性接口，即将某个其他接口定义为该接口的属性，好变态！这个我们当前应用也不会出现这种情况!
				subinterfaceDescs.Add(BuildInternal(propertyInfo.Name, propertyInfo.PropertyType));
			}

			#endregion

			//针对每个Interface接口提取其定义的方法，这里的Where就是剔除是接口中定义的属性(属性是隐含的get/set方法)
			var methods = allInterfaces.SelectMany(x => x.GetMethods(BindingFlags.Public | BindingFlags.Instance))
				.Where(m => !properties.Any(p => p.GetMethod == m || p.SetMethod == m));

			var methodDescs = methods.Select(methodInfo => methodDescriptionBuilder.Build(methodInfo)).ToArray();
			return new ServiceDescription
			{
				Type = interfaceType,
				Name = name,
				Subservices = subinterfaceDescs,
				Methods = methodDescs
			};
		}

		private static IEnumerable<Type> GetAllInterfaces(Type baseInterface)
		{
			yield return baseInterface;

			foreach (var subInterface in baseInterface.GetInterfaces())
				foreach (var subsubinterface in GetAllInterfaces(subInterface))
					yield return subsubinterface;
		} 
	}
}

