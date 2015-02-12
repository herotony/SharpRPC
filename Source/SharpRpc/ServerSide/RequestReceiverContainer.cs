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
using SharpRpc.Logs;

namespace SharpRpc.ServerSide
{
    public class RequestReceiverContainer : IRequestReceiverContainer 
    {
        private readonly IIncomingRequestProcessor requestProcessor;
        private readonly ILogger logger;
        private HttpRequestReceiver httpReceiver;
		private TcpRequestReceiver2 tcpReceiver;

        public RequestReceiverContainer(IIncomingRequestProcessor requestProcessor, ILogger logger)
        {
            this.requestProcessor = requestProcessor;
            this.logger = logger;
        }

        public IRequestReceiver GetReceiver(string protocol)
        {
            switch (protocol)
            {
                case "http": return httpReceiver ?? (httpReceiver = new HttpRequestReceiver(requestProcessor, logger));
				case "tcp":return tcpReceiver ?? (tcpReceiver = new TcpRequestReceiver2 (requestProcessor, logger));
                default: throw new NotSupportedException(string.Format("Protocol '{0}' is not supported", protocol));
            }
        }
    }
}