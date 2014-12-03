using System;
using System.Threading;
using System.Threading.Tasks;
using SharpRpc.ProxyMyService;

namespace SharpRpc.RealMyService
{
	public class MyService : IMyService
	{
		public int Add(int a, int b)
		{
			return a + b;
		}

		public Task<int> AddAsync(int a, int b)
		{
			return Task.FromResult(a + b);
		}

		public string Greet(string name)
		{
			if (name == "exception")
				throw new Exception("Hello!!!");
			return string.Format("Hello, {0}!", name);
		}

		public void Throw()
		{
			throw new DivideByZeroException("Because we can!");
		}

		public void SleepOneSecond()
		{
			Thread.Sleep(1000);
		}
	}
}

