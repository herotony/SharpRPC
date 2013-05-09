﻿#region License
/*
Copyright (c) 2013 Daniil Rodin of Buhgalteria.Kontur team of SKB Kontur

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

using NSubstitute;
using NUnit.Framework;
using SharpRpc.ClientSide;
using System.Linq;
using SharpRpc.Codecs;
using SharpRpc.Reflection;

namespace SharpRpc.Tests.ClientSide
{
    [TestFixture]
    public unsafe class ServiceProxyClassFactoryTests
    {
        private IServiceDescriptionBuilder serviceDescriptionBuilder;
        private ICodecContainer codecContainer;
        private IOutgoingMethodCallProcessor methodCallProcessor;
        private ServiceProxyClassFactory factory;

        [SetUp]
        public void Setup()
        {
            serviceDescriptionBuilder = new ServiceDescriptionBuilder(new MethodDescriptionBuilder());
            codecContainer = new CodecContainer();
            methodCallProcessor = Substitute.For<IOutgoingMethodCallProcessor>();
            factory = new ServiceProxyClassFactory(serviceDescriptionBuilder, codecContainer);
        }

        public interface ITrivialService
        {
            void DoSomething();
        }

        [Test]
        public void Trivial()
        {
            var proxy = factory.CreateProxyClass<ITrivialService>()(methodCallProcessor, null);
            methodCallProcessor.Process(null, null, null, null).ReturnsForAnyArgs((byte[])null);

            proxy.DoSomething();

            var arguments = methodCallProcessor.ReceivedCalls().Single().GetArguments();
            Assert.That(arguments[0], Is.EqualTo(typeof(ITrivialService)));
            Assert.That(arguments[1], Is.EqualTo("TrivialService/DoSomething"));
            Assert.That(arguments[2], Is.Null);
            Assert.That(arguments[3], Is.Null);
        }

        [Test]
        public void TrivialScoped()
        {
            var proxy = factory.CreateProxyClass<ITrivialService>()(methodCallProcessor, "my scope");
            methodCallProcessor.Process(null, null, null, null).ReturnsForAnyArgs((byte[])null);

            proxy.DoSomething();

            var arguments = methodCallProcessor.ReceivedCalls().Single().GetArguments();
            Assert.That(arguments[0], Is.EqualTo(typeof(ITrivialService)));
            Assert.That(arguments[1], Is.EqualTo("TrivialService/DoSomething"));
            Assert.That(arguments[2], Is.EqualTo("my scope"));
            Assert.That(arguments[3], Is.Null);
        }

        public interface IArgumentsService
        {
            void MethodWithArgs(int a, double b);
            double MethodWithRetval();
        }

        [Test]
        public void Arguments()
        {
            var proxy = factory.CreateProxyClass<IArgumentsService>()(methodCallProcessor, null);
            methodCallProcessor.Process(null, null, null, null).ReturnsForAnyArgs((byte[])null);

            proxy.MethodWithArgs(123, 234.567);

            var expectedArgsData = new byte[12];
            fixed (byte* pData = expectedArgsData)
            {
                *(int*)pData = 123;
                *(double*)(pData + 4) = 234.567;
            }

            var arguments = methodCallProcessor.ReceivedCalls().Single().GetArguments();
            Assert.That(arguments[0], Is.EqualTo(typeof(IArgumentsService)));
            Assert.That(arguments[1], Is.EqualTo("ArgumentsService/MethodWithArgs"));
            Assert.That(arguments[2], Is.Null);
            Assert.That(arguments[3], Is.EqualTo(expectedArgsData));
        }

        public interface IRetvalService
        {
            double MethodWithRetval();
        }

        [Test]
        public void Retval()
        {
            var retvalData = new byte[sizeof(double)];
            fixed (byte* pData = retvalData)
            {
                *(double*)pData = 123.456;
            }

            var proxy = factory.CreateProxyClass<IRetvalService>()(methodCallProcessor, null);
            methodCallProcessor.Process(null, null, null, null).ReturnsForAnyArgs(retvalData);

            var retval = proxy.MethodWithRetval();

            var arguments = methodCallProcessor.ReceivedCalls().Single().GetArguments();
            Assert.That(arguments[0], Is.EqualTo(typeof(IRetvalService)));
            Assert.That(arguments[1], Is.EqualTo("RetvalService/MethodWithRetval"));
            Assert.That(arguments[2], Is.Null);
            Assert.That(arguments[3], Is.Null);
            Assert.That(retval, Is.EqualTo(123.456));
        }

        public interface ISuperService
        {
            ITrivialService Trivial { get; }
        }

        [Test]
        public void Subservice()
        {
            var proxy = factory.CreateProxyClass<ISuperService>()(methodCallProcessor, null);
            methodCallProcessor.Process(null, null, null, null).ReturnsForAnyArgs((byte[])null);

            proxy.Trivial.DoSomething();

            var arguments = methodCallProcessor.ReceivedCalls().Single().GetArguments();
            Assert.That(arguments[0], Is.EqualTo(typeof(ITrivialService)));
            Assert.That(arguments[1], Is.EqualTo("SuperService/Trivial/DoSomething"));
            Assert.That(arguments[2], Is.Null);
            Assert.That(arguments[3], Is.Null);
        }
    }
}