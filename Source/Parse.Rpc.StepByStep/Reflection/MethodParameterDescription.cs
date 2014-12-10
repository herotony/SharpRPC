using System;
using System.Collections.Generic;

namespace Parse.Rpc.StepByStep.Reflection
{
	public class MethodParameterDescription
	{
		public int Index { get; private set; }
		public Type Type { get; private set; }
		public string Name { get; private set; }
		public MethodParameterWay Way { get; private set; }

		//记录方法的参数所在位置，名称以及类型和传递方式
		public MethodParameterDescription(int index, Type type, string name, MethodParameterWay way = MethodParameterWay.Val)
		{
			Index = index;
			if (type == null)
				throw new ArgumentNullException("type");

			if (string.IsNullOrWhiteSpace(name))
				throw new ArgumentException("Method parameter name cannot be null, empty, or consist of whitespace characters");

			Type = type;
			Name = name;
			Way = way;
		}

		//该方法的意义：针对类似KeyValue<TKey,TValue>的类型深挖出其TKey和TValue的类型，而传入参数genericArguments则只是其中的一个参考而已...
		//              岂非意味着，所有的MethodParamterDescription都应该默认调用一次此方法？
		public MethodParameterDescription DeepSubstituteGenerics(IReadOnlyDictionary<string, Type> genericArguments)
		{
			return new MethodParameterDescription(Index, Type.DeepSubstituteGenerics(genericArguments), Name, Way);
		}
	}
}

