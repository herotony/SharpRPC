#region License
/*
Copyright (c) 2013-2014 Daniil Rodin of Buhgalteria.Kontur team of SKB Kontur

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
#endregion

using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
//using SharpRpc.TestCommon;
using SharpRpc.ProxyMyService;
using SharpRpc.Topology;
using Sharp.Rpc.CommonObject;
using System.Diagnostics;
using System.Threading.Tasks;

namespace SharpRpc.TestClient
{
    class Program
    {
        static void Main(string[] args)
        {
			//TestMyService();
			try{
			
					TestComplex ();

			}catch(Exception e){

				string message = string.Format ("desc:{0}\r\nstackTrace:{1}", e.Message, e.StackTrace);

			}

        }

		private static void TestComplex(){

			var topologyLoader = new TopologyLoader("../Topology/topology.txt", Encoding.UTF8, new TopologyParser());
			var client = new RpcClient(topologyLoader, new TimeoutSettings(500));

			var complexService = client.GetService<IComplexService> ();

			for (int i = 0; i < 2; i++) {
			
				Task.Factory.StartNew (() => {
				
					Console.WriteLine(Task.CurrentId);
					byte[] result = complexService.GetStudentList (new byte[1]);
				});
			}

			Stopwatch sw = new Stopwatch ();

			sw.Start ();

			for (int m = 0; m < 2; m++) {

				byte[] result = complexService.GetStudentList (new byte[1]);

				List<Student> list = Google.ProtoBuf.Serializer.Deserialize<List<Student>> (new MemoryStream (result));

				for (int i = 0; i < list.Count; i++) {

					Console.WriteLine (list [i].ToString ());
					for (int j = 0; j < list [i].Address.Count; j++)
						Console.WriteLine (list [i].Address [j]);
				}
			}

//			Task[] tasks = new Task[2];
//
//			for (int k = 0; k < tasks.Length; k++) {
//
//				tasks[k]=new Task (() => {
//
//
//
//					try{
//
//
//
//					}catch{}
//
//
//				});
//
//			}
//
//			for (int k = 0; k < tasks.Length; k++)
//				tasks [k].Start ();
				

			//Task.WaitAll (tasks);

			Console.WriteLine (string.Format ("耗时:{0}毫秒", sw.ElapsedMilliseconds));
				
			Console.ReadKey ();

		}



		private static void TestMyService(){

			var topologyLoader = new TopologyLoader("../Topology/topology.txt", Encoding.UTF8, new TopologyParser());
			var client = new RpcClient(topologyLoader, new TimeoutSettings(500));

			var myService = client.GetService<IMyService>();

			string line;
			while ((line = Console.ReadLine()) != "exit")
			{
				switch (line)
				{
				case "greet":
					{
						Console.Write("Enter a name: ");
						var name = Console.ReadLine();
						var greeting = myService.Greet(name);
						Console.WriteLine(greeting);
					}
					break;
				case "add":
					{
						Console.Write("Enter a: ");
						var a = int.Parse(Console.ReadLine());
						Console.Write("Enter b: ");
						var b = int.Parse(Console.ReadLine());
						var sum = myService.Add(a, b);
						Console.WriteLine(sum);
					}
					break;
				case "aadd":
					{
						Console.Write("Enter a: ");
						var a = int.Parse(Console.ReadLine());
						Console.Write("Enter b: ");
						var b = int.Parse(Console.ReadLine());
						var sum = myService.AddAsync(a, b).Result;
						Console.WriteLine(sum);
					}
					break;
				case "throw":
					{
						try
						{
							myService.Throw();
						}
						catch (Exception ex)
						{
							Console.WriteLine(ex);
						}
					}
					break;
				case "sleep":
					{
						try
						{
							myService.SleepOneSecond();
						}
						catch (Exception ex)
						{
							Console.WriteLine(ex);
						}
					}
					break;
				default:
					{
						Console.WriteLine("Unkown command");    
					}
					break;
				}
			}

		}
    }
}
