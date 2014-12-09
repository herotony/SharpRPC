using System;
using NSubstitute;
using NUnit.Framework;

namespace HeroTonyLearnNUnit
{
	public interface ICalculator
	{
		int Add(int a, int b);
		string Mode { get; set; }
		event EventHandler PoweringUp;
	}

	public class CaculatorWatcher{

		ICalculator _cal;

		public CaculatorWatcher(ICalculator cal){

			_cal = cal;
			_cal.PoweringUp += OnExecute;
		}

		public bool DidStuff{ get;private set;}

		public void OnExecute(object sender,EventArgs arg){

			DidStuff = true;
		}
	}

	[TestFixture]
	public class BasicConceptTest
	{
		[Test]
		public void TestICalculator(){

			var caculator = Substitute.For<ICalculator> ();

			//设定Add(1,2)返回3
			caculator.Add (1, 2).Returns (3);

			//caculator.Add (3, 1);
			//caculator.Received ().Add (1, 2);
			//caculator.DidNotReceive ().Add (5, 7);

			Assert.That (caculator.Add (1, 2), Is.EqualTo (3));

			caculator.ClearReceivedCalls ();

			caculator.Received ().Add (1, 2);
		}

		[Test]
		public void TestEventSubscribe(){

			var cal = Substitute.For<ICalculator> ();
			var calWatcher = Substitute.For<CaculatorWatcher> (cal);

			//触发事件
			//cal.PoweringUp += Raise.Event ();

			Assert.That (calWatcher.DidStuff);

		}

	}
}

