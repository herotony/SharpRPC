using System.Reflection.Emit;

namespace Parse.Rpc.StepByStep.Codecs
{
	public class ForLoopEmitter :IForLoopEmitter
	{
		private readonly MyILGenerator il;
		private readonly LocalBuilder lengthVar;
		private LocalBuilder iVar;
		private Label loopStartLabel;
		private Label loopConditionLabel;

		public ForLoopEmitter (MyILGenerator il, LocalBuilder lengthVar)
		{
			this.il = il;
			this.lengthVar = lengthVar;
			EmitLoopBeginning();
		}

		public void Dispose()
		{
			EmitLoopEnd();
		}

		public void LoadIndex()
		{
			il.Ldloc(iVar);
		}
			
		private void EmitLoopBeginning()
		{
			loopStartLabel = il.DefineLabel();
			loopConditionLabel = il.DefineLabel();

			iVar = il.DeclareLocal(typeof(int));        // int i

			il.Ldc_I4(0);                               // i = 0
			il.Stloc(iVar);
			il.Br(loopConditionLabel);                  // goto loopConditionLabel

			il.MarkLabel(loopStartLabel);               // label loopStartLabel
		}

		private void EmitLoopEnd()
		{
			il.Ldloc(iVar);                             // i++
			il.Ldc_I4(1);
			il.Add();
			il.Stloc(iVar);

			il.MarkLabel(loopConditionLabel);           // label loopConditionLabel
			il.Ldloc(iVar);                             // if (i < (int)value.Length)
			il.Ldloc(lengthVar);                        //     goto loopStartLabel
			il.Blt(loopStartLabel);
		}
	}
}

