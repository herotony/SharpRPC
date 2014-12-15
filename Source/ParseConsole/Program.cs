using System;
using System.Windows.Forms;
using System.Threading;
using System.Threading.Tasks;


namespace ParseConsole
{
	class MainClass
	{
		//[STAThread]
		public static void Main (string[] args)
		{
//			Application.EnableVisualStyles ();
//			Application.SetCompatibleTextRenderingDefault (false);
//
//			var ctx = SynchronizationContext.Current;
//
//			if (ctx == null)
//				MessageBox.Show ("not context for this thread");
//			else
//				MessageBox.Show ("we got a context");
//
//			Form form = new Form ();
//
//			ctx = SynchronizationContext.Current;
//
//			if (ctx == null)
//				MessageBox.Show ("not context for this thread!");
//			else
//				MessageBox.Show ("we got a context!");
//
//			Application.Run (new Form ());

			method ();
			Console.WriteLine ("Hello World!");
			Console.ReadKey ();
		}

		//加了async/await,则整个method方法都必须等待Task.Run的返回
		//亦即，method已经不属于主线程了，这在UI编程上倒是很方便了。
		private static async  void method(){

			//await决定了方法method不会block调用者Main,但method本身的后续部分则必须等待其完成。
			await Task.Run(() => {

				Thread.Sleep(10000);
				Console.WriteLine("run over!");

			});

			Console.WriteLine (" in method");

		}
	}
}
