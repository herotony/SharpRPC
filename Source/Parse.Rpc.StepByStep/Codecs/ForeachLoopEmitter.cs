﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Reflection.Emit;

namespace Parse.Rpc.StepByStep.Codecs
{
	public class ForeachLoopEmitter :IForeachLoopEmitter
	{
		private readonly MyILGenerator il;
		private readonly Action<MyILGenerator> emitLoadCollection;

		private readonly Type enumerableType;
		private readonly Type enumeratorType;

		private Label loopStartLabel;
		private Label loopConditionLabel;
		private LocalBuilder enumeratorVar;

		public ForeachLoopEmitter(MyILGenerator il, Type elementType, Action<MyILGenerator> emitLoadCollection)
		{
			this.il = il;
			this.emitLoadCollection = emitLoadCollection;
			enumerableType = typeof(IEnumerable<>).MakeGenericType(elementType);
			enumeratorType = typeof(IEnumerator<>).MakeGenericType(elementType);
			EmitLoopBeginning();
		}

		private MethodInfo GetEnumeratorMethod { get { return enumerableType.GetMethod("GetEnumerator"); } }
		private MethodInfo GetCurrentMethod { get { return enumeratorType.GetMethod("get_Current"); } }
		private static MethodInfo MoveNextMethod { get { return typeof(IEnumerator).GetMethod("MoveNext"); } }

		public void Dispose()
		{
			EmitLoopEnd();
		}

		public void LoadCurrent()
		{
			il.Ldloc(enumeratorVar);
			il.Callvirt(GetCurrentMethod);
		}

		private void EmitLoopBeginning()
		{
			loopStartLabel = il.DefineLabel();
			loopConditionLabel = il.DefineLabel();
			enumeratorVar = il.DeclareLocal(enumeratorType);    // IEnumerator<T> enumerator

			emitLoadCollection(il);                             // enumerator = value.GetEnumerator()
			il.Callvirt(GetEnumeratorMethod);
			il.Stloc(enumeratorVar);
			il.Br(loopConditionLabel);                          // goto loopConditionLabel
			il.MarkLabel(loopStartLabel);                       // label loopStartLabel
		}

		private void EmitLoopEnd()
		{
			il.MarkLabel(loopConditionLabel);                   // label loopConditionLabel
			il.Ldloc(enumeratorVar);                            // if (i < (int)value.Length)
			il.Callvirt(MoveNextMethod);                        //     goto loopStartLabel
			il.Brtrue(loopStartLabel);
		}
	}
}

