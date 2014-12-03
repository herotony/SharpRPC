using System;
using System.Threading.Tasks;

namespace SharpRpc.ProxyMyService
{
	public interface IMyService
	{
		int Add(int a, int b);
		Task<int> AddAsync(int a, int b);
		string Greet(string name);
		void Throw();
		void SleepOneSecond();
	}
}

