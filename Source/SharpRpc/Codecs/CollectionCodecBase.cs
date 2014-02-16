﻿#region License
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
using System.Reflection.Emit;

namespace SharpRpc.Codecs
{
    public abstract class CollectionCodecBase : IEmittingCodec
    {
        private readonly Type type;
        private readonly Type elementType;
        private readonly IEmittingCodec elementCodec;

        public Type Type { get { return type; } }
        public int? FixedSize { get { return null; } }
        public int? MaxSize { get { return null; } }
        public bool CanBeInlined { get { return elementCodec.CanBeInlined; } }
        public int EncodingComplexity { get { return elementCodec.EncodingComplexity; } }

        protected Type ElementType { get { return elementType; } }
        protected IEmittingCodec ElementCodec { get { return elementCodec; } }

        protected CollectionCodecBase(Type type, Type elementType, ICodecContainer codecContainer)
        {
            this.type = type;
            this.elementType = elementType;
            elementCodec = codecContainer.GetEmittingCodecFor(elementType);
        }

        protected abstract void EmitCreateCollection(ILGenerator il, LocalBuilder lengthVar);
        protected abstract void EmitLoadCount(ILGenerator il, Action<ILGenerator> emitLoad);
        protected abstract void EmitDecodeAndStore(IEmittingContext context, LocalBuilder collectionVar, Action emitLoadIndex, bool doNotCheckBounds);

        public void EmitCalculateSize(IEmittingContext context, Action<ILGenerator> emitLoad)
        {
            var il = context.IL;
            var valueIsNullOrEmptyLabel = il.DefineLabel();
            var valueHasElementsLabel = il.DefineLabel();
            var endOfMethodLabel = il.DefineLabel();

            var elemVar = il.DeclareLocal(elementType);                     // T elem

            emitLoad(il);                                                   // if (!value)
            il.Emit(OpCodes.Brfalse, valueIsNullOrEmptyLabel);//               goto valueIsNullOrEmptyLabel

            EmitLoadCount(il, emitLoad);                                    // if ((int)value.Length)
            il.Emit(OpCodes.Brtrue, valueHasElementsLabel);                 //     goto valueHasElementsLabel

            il.MarkLabel(valueIsNullOrEmptyLabel);                          // label valueIsNullOrEmptyLabel
            il.Emit_Ldc_I4(sizeof(int));                                    // stack_0 = sizeof(int)
            il.Emit(OpCodes.Br, endOfMethodLabel);                          // goto endOfMethodLabel

            il.MarkLabel(valueHasElementsLabel);                            // label valueHasElementsLabel
            il.Emit_Ldc_I4(sizeof(int));                                    // sum = sizeof(int)
            using (var loop = il.EmitForeachLoop(elementType, emitLoad))    // foreach (current in value) 
            {
                loop.LoadCurrent();                                         //     elem = current
                il.Emit(OpCodes.Stloc, elemVar);
                elementCodec.EmitCalculateSize(context, elemVar);           //     stack_1 = CalculateSize(elem)
                il.Emit(OpCodes.Add);                                       //     stack_0 = stack_0 + stack_1
            }
            il.MarkLabel(endOfMethodLabel);                                 // label endOfMethodLabel
        }

        public void EmitEncode(IEmittingContext context, Action<ILGenerator> emitLoad)
        {
            var il = context.IL;
            var valueIsNotNullLabel = il.DefineLabel();
            var endOfMethodLabel = il.DefineLabel();

            var elemVar = il.DeclareLocal(elementType);                     // TElement elem

            emitLoad(il);                                                   // if (value)
            il.Emit(OpCodes.Brtrue, valueIsNotNullLabel);                   //     goto valueIsNotNullLabel

            // value is null branch
            il.Emit(OpCodes.Ldloc, context.DataPointerVar);                 // *(int*) data = -1
            il.Emit_Ldc_I4(-1);
            il.Emit(OpCodes.Stind_I4);
            il.Emit_IncreasePointer(context.DataPointerVar, sizeof(int));   // data += sizeof(int)
            il.Emit(OpCodes.Br, endOfMethodLabel);                          // goto endOfMethodLabel

            // value is not null branch
            il.MarkLabel(valueIsNotNullLabel);                              // label valueIsNotNullLabel
            il.Emit(OpCodes.Ldloc, context.DataPointerVar);                 // *(int*) data = (int)value.Count
            EmitLoadCount(il, emitLoad);
            il.Emit(OpCodes.Stind_I4);
            il.Emit_IncreasePointer(context.DataPointerVar, sizeof(int));   // data += sizeof(int)
            using (var loop = il.EmitForeachLoop(elementType, emitLoad))    // foreach (current in value)
            {
                loop.LoadCurrent();                                         //     elem = current
                il.Emit(OpCodes.Stloc, elemVar);
                elementCodec.EmitEncode(context, elemVar);                  //     encode(data, elem)
            }
            il.MarkLabel(endOfMethodLabel);                                 // label endOfMethodLabel
        }

        public void EmitDecode(IEmittingContext context, bool doNotCheckBounds)
        {
            var il = context.IL;
            var valueIsNotNullLabel = il.DefineLabel();
            var endOfMethodLabel = il.DefineLabel();

            var resultVar = il.DeclareLocal(type);                      // TCollection result

            if (!doNotCheckBounds)
            {
                var canReadLengthLabel = il.DefineLabel();
                il.Emit(OpCodes.Ldloc, context.RemainingBytesVar);      // if (remainingBytes >= sizeof(int))
                il.Emit_Ldc_I4(sizeof(int));                            //     goto canReadLengthLabel
                il.Emit(OpCodes.Bge, canReadLengthLabel);
                il.Emit_ThrowUnexpectedEndException();                  // throw new InvalidDataException("...")
                il.MarkLabel(canReadLengthLabel);                       // label canReadLengthLabel
            }

            var lengthVar = il.DeclareLocal(typeof(int));               // var length = *(int*) data
            il.Emit(OpCodes.Ldloc, context.DataPointerVar);
            il.Emit(OpCodes.Ldind_I4);
            il.Emit(OpCodes.Stloc, lengthVar);
            il.Emit_IncreasePointer(context.DataPointerVar, sizeof(int));   // data += sizeof(int)
            il.Emit_DecreaseInteger(context.RemainingBytesVar, sizeof(int));// remainingBytes -= sizeof(int)
            il.Emit(OpCodes.Ldloc, lengthVar);                              // if (length != -1)
            il.Emit_Ldc_I4(-1);                                             //     goto valueIsNotNullLabel
            il.Emit(OpCodes.Bne_Un, valueIsNotNullLabel);

            il.Emit(OpCodes.Ldnull);                                    // stack_0 = null
            il.Emit(OpCodes.Br, endOfMethodLabel);                      // goto endOfMethodLabel

            il.MarkLabel(valueIsNotNullLabel);                          // label valueIsNotNullLabel
            EmitCreateCollection(il, lengthVar);                        // result = new TCollection()
            il.Emit(OpCodes.Stloc, resultVar);

            using (var loop = il.EmitForLoop(lengthVar))                // for (int i = 0; i < length; i++)
            {                                                           //     result.Add(decode(data, remainingBytes))
                EmitDecodeAndStore(context, resultVar,
                                   loop.LoadIndex, doNotCheckBounds);
            }

            il.Emit(OpCodes.Ldloc, resultVar);                          // stack_0 = result
            il.MarkLabel(endOfMethodLabel);                             // label endOfMethodLabel
        }
    }
}