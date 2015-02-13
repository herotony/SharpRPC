<map version="1.0.1">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1419576960326" ID="ID_1675323572" MODIFIED="1419577193382" TEXT="SharpRpc">
<node CREATED="1419582998528" FOLDED="true" ID="ID_671033355" MODIFIED="1420512823210" POSITION="right" TEXT="TestHost">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      static void Main(string[] args)
    </p>
    <p>
      {
    </p>
    <p>
      &#160;&#160;&#160;var topologyLoader = new TopologyLoader(&quot;../Topology/topology.txt&quot;, Encoding.UTF8, new TopologyParser());
    </p>
    <p>
      &#160;&#160;&#160;var settingsLoader = new SettingsLoader(&quot;../Settings/Host.txt&quot;,
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Encoding.UTF8, new HostSettingsParser());
    </p>
    <p>
      &#160;&#160;&#160;var kernel = new <font color="#0000cc">RpcClientServer</font>(topologyLoader, new TimeoutSettings(5000), settingsLoader);
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;<b><font color="#006666">&#160;kernel.StartHost();</font></b>
    </p>
    <p>
      
    </p>
    <p style="text-align: left">
      &#160;&#160;&#160;&#160;string line = Console.ReadLine();
    </p>
    <p style="text-align: left">
      &#160;&#160;&#160;&#160;while (line != &quot;exit&quot;)
    </p>
    <p style="text-align: left">
      &#160;&#160;&#160;&#160;{
    </p>
    <p style="text-align: left">
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;line = Console.ReadLine();
    </p>
    <p style="text-align: left">
      &#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;<b><font color="#330066">kernel.StopHost();</font></b>
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
<node CREATED="1419578956464" ID="ID_1044812488" MODIFIED="1419732689919" TEXT="RpcClientServer">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      public class RpcClientServer : IRpcClientServer
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IReadOnlyDictionary&lt;string, IServiceTopology&gt; topology;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly TimeoutSettings defaultTimeout;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IHostSettings settings;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IServiceImplementationContainer serviceImplementationContainer;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly ILogger logger;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IRequestReceiver requestReceiver;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IProxyContainer proxyContainer;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public RpcClientServer(ITopologyLoader <font color="#0000ff"><b>topologyLoader</b></font>, TimeoutSettings <font color="#0000ff"><b>defaultTimeout</b></font>, ISettingsLoader <font color="#0000ff"><b>settingsLoader</b></font>, RpcComponentOverrides componentOverrides = null)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<font color="#6600cc"><b>topology</b></font>&#160;= topologyLoader.Load();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.defaultTimeout = defaultTimeout;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;settings = settingsLoader.LoadHostSettings();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var <font color="#ff6600">componentContainer</font>&#160; = new <font color="#ff6600"><b>RpcClientServerComponentContainer</b></font>(this, componentOverrides ?? new RpcComponentOverrides());
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;logger = componentContainer.GetLogger();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;serviceImplementationContainer = <font color="#ff6600">componentContainer</font>.GetServiceImplementationContainer();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<font color="#ff0000"><b>requestReceiver</b></font>&#160; = <font color="#ff6600">componentContainer</font>.GetRequestReceiverContainer().GetReceiver(settings.EndPoint.Protocol);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<font color="#0000ff">proxyContainer</font>&#160; =<font color="#ff6600">&#160;&#160;componentContainer</font>.GetIServiceProxyContainer();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IReadOnlyDictionary&lt;string, IServiceTopology&gt; <font color="#330066"><b>Topology</b></font>&#160; { get { return <font color="#6600ff"><b>topology</b></font>; } }&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public T <font color="#cc00ff"><b>GetService&lt;T&gt;</b></font>(string scope, TimeoutSettings timeoutSettings) where T : class{...}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public void <font color="#6600ff"><b>StartHost</b></font>()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<font color="#ff0000"><b>requestReceiver</b></font>.Start(settings.EndPoint.Port, Environment.ProcessorCount);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public void <font color="#6600ff"><b>StopHost</b></font>()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;requestReceiver.Stop();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IEnumerable&lt;string&gt; <font color="#6600ff">GetInitializedScopesFor</font>(string serviceName)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return serviceImplementationContainer.GetInitializedScopesFor(serviceName);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public TimeoutSettings DefaultTimeout { get { return defaultTimeout; } }
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IHostSettings Settings { get { return settings; } }
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public ILogger Logger { get { return logger; }}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
<node CREATED="1419581442960" ID="ID_573154011" MODIFIED="1419755157757" TEXT="&#x6784;&#x9020;&#x51fd;&#x6570;&#x521d;&#x59cb;&#x5316;">
<node CREATED="1419579057664" FOLDED="true" ID="ID_1351832423" MODIFIED="1419754276490" TEXT="RpcClientServerComponentContainer  componentContainer = new ...">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;&#160;&#160;&#160;public class RpcClientServerComponentContainer : <font color="#6600cc">RpcClientComponentContainer</font>, <font color="#0033cc">IRpcClientServerComponentContainer</font>
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IRpcClientServer clientServer;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly RpcComponentOverrides overrides;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private ILogger logger;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private IServiceImplementationContainer serviceImplementationContainer;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private IServiceImplementationFactory serviceImplementationFactory;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private IRawHandlerFactory rawHandlerFactory;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private IHandlerFactory handlerFactory;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private IHandlerContainer handlerContainer;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private IIncomingRequestProcessor incomingRequestProcessor;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private IRequestReceiverContainer requestReceiverContainer;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public RpcClientServerComponentContainer(IRpcClientServer <b><font color="#ff0000">clientServer</font></b>, RpcComponentOverrides <b><font color="#ff0000">overrides</font></b>)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;: base(clientServer, overrides)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.clientServer = clientServer;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.overrides = overrides;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IRpcClientServer ClientServer { get { return clientServer; } }
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IRequestReceiverContainer <font color="#0000cc">GetRequestReceiverContainer</font>() {...}&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public ILogger GetLogger(){...}&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IServiceImplementationContainer GetServiceImplementationContainer(){...}&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IServiceImplementationFactory GetServiceImplementationFactory(){...}&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IRawHandlerFactory <font color="#cc00ff">GetServiceMethodDelegateFactory</font>(){...}&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IHandlerFactory <font color="#0000ff">GetServiceMethodHandlerFactory</font>(){...}&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IHandlerContainer GetServiceMethodHandlerContainer(){...}&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IIncomingRequestProcessor <font color="#ff0000">GetIncomingRequestProcessor</font>(){...}&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
<node CREATED="1419729976159" ID="ID_1735481938" MODIFIED="1419730601947" TEXT="componetContainer.GetServiceImplementationFactory()">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IServiceImplementationFactory GetServiceImplementationFactory()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return serviceImplementationFactory ?? (serviceImplementationFactory =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; overrides.ServiceImplementationFactory != null
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;? overrides.ServiceImplementationFactory(this)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;: <font color="#0000ff">new</font>&#160; <b><font color="#006600">ServiceImplementationFactory</font></b>(<font color="#006666">GetServiceDescriptionBuilder()</font>, ClientServer, <font color="#006666">ClientServer.Settings.GetInterfaceImplementationsPairs()</font>));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
<node CREATED="1419730851111" ID="ID_268706868" LINK="#ID_545583851" MODIFIED="1419732208267" TEXT="ServiceImplementationFactory">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      public class ServiceImplementationFactory : IServiceImplementationFactory
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;#region Nester Structs
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private <font color="#0000ff">struct</font>&#160;<b><font color="#006666">ImplementationCreationInfo</font></b>
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public ServiceDescription Description;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public ConstructorInfo Constructor;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;#endregion
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IServiceDescriptionBuilder serviceDescriptionBuilder;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IRpcClientServer clientServer;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly ConcurrentDictionary&lt;string, ImplementationCreationInfo&gt; constructors;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public <font color="#0000ff">ServiceImplementationFactory</font>(IServiceDescriptionBuilder <font color="#006600">serviceDescriptionBuilder</font>, IRpcClientServer <font color="#006600">clientServer</font>,
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;IEnumerable&lt;InterfaceImplementationTypePair&gt; <font color="#006600">interfaceImplementationTypePairs</font>)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.serviceDescriptionBuilder = serviceDescriptionBuilder;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.clientServer = clientServer;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;constructors = new ConcurrentDictionary&lt;string, ImplementationCreationInfo&gt;(interfaceImplementationTypePairs.Select(<font color="#6600cc">ConvertPair</font>));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public bool <b><font color="#006666">CanCreate</font></b>(string serviceName)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return constructors.ContainsKey(serviceName);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public ServiceImplementationInfo <b><font color="#006666">CreateImplementation</font></b>(string serviceName, string scope)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;ImplementationCreationInfo creationInfo;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (!constructors.TryGetValue(serviceName, out creationInfo))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;throw new ArgumentOutOfRangeException(&quot;serviceName&quot;, string.Format(&quot;Implementation for service '{0}' was not found&quot;, serviceName));
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return <font color="#0000ff">new</font>&#160; <b><font color="#006666">ServiceImplementationInfo</font></b>(creationInfo.<font color="#006600">Description</font>, <font color="#006666">InvokeConstructor</font>(creationInfo.Constructor, clientServer, scope));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private KeyValuePair&lt;string, ImplementationCreationInfo&gt; <b><font color="#6600cc">ConvertPair</font></b>(InterfaceImplementationTypePair pair)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var serviceName = pair.Interface.GetServiceName();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (!pair.Interface.IsAssignableFrom(pair.ImplementationType))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;throw new ArgumentException(string.Format(&quot;Given implementation for a '{0}' service ({1}) does not implement its interface&quot;, serviceName, pair.ImplementationType.FullName));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var constructor = <font color="#0000ff">FindLargestAppropriateConstructor</font>(pair.ImplementationType);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (constructor == null)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;throw new ArgumentException(string.Format(&quot;No appropriate constructor found for {0}&quot;, pair.ImplementationType.FullName));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var creationInfo = new ImplementationCreationInfo
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Constructor = constructor,
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Description = <b><font color="#cc0000">serviceDescriptionBuilder.Build</font></b>(pair.Interface)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;};
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return new KeyValuePair&lt;string, ImplementationCreationInfo&gt;(pair.Interface.GetServiceName(), creationInfo);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static ConstructorInfo <font color="#0000ff">FindLargestAppropriateConstructor</font>(Type type)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return <b><font color="#cc0000">type.GetConstructors</font></b>()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;.Where(x =&gt; x.GetParameters().All(ParameterIsInjectable))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;.OrderBy(x =&gt; x.GetParameters().Length)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;.FirstOrDefault();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static bool <b><font color="#6600cc">ParameterIsInjectable</font></b>(ParameterInfo parameterInfo)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var type = parameterInfo.ParameterType;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return type == typeof(string) || type == typeof(IRpcClient) || type == typeof(IRpcClientServer);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static object <b><font color="#006666">InvokeConstructor</font></b>(ConstructorInfo constructor, IRpcClientServer clientServer, string scope)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var arguments = constructor.GetParameters().Select(x =&gt;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var paramType = x.ParameterType;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (paramType == typeof(string))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return (object)scope;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (paramType == typeof(IRpcClient) || paramType == typeof(IRpcClientServer))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return (object)clientServer;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;throw new InvalidOperationException(&quot;Should never happen&quot;);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}).ToArray();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return constructor.Invoke(arguments);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1419730696791" ID="ID_426934126" MODIFIED="1419730768209" TEXT="componentContainer.GetServiceDescriptionBuilder()">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      public IServiceDescriptionBuilder GetServiceDescriptionBuilder()&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      {&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;return serviceDescriptionBuilder ?? (serviceDescriptionBuilder = <font color="#0000ff">new</font>&#160;<b><font color="#006600">ServiceDescriptionBuilder</font></b>(<font color="#0000ff">new</font>&#160; <b><font color="#006666">MethodDescriptionBuilder</font></b>()));&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1419732958023" ID="ID_384151352" LINK="#ID_705362828" MODIFIED="1419734766168" TEXT="componentContainer.GetOutgoingMethodCallProcessor()">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;public IOutgoingRequestProcessor GetOutgoingMethodCallProcessor()&#160;&#160;&#160;&#160;&#160;&#160; &#160;
    </p>
    <p>
      {&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;return outgoingRequestProcessor ?? (outgoingRequestProcessor =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; overrides.OutgoingMethodCallProcessor != null
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;? overrides.OutgoingMethodCallProcessor(this)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;: <font color="#0000ff">new</font>&#160; <b><font color="#006666">OutgoingRequestProcessor</font></b>(client.Topology, <font color="#006600">GetRequestSenderContainer</font>(), <font color="#006600">GetCodecContainer</font>()));&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1419733369799" ID="ID_1592083148" LINK="#ID_705362828" MODIFIED="1419734898586" TEXT="componentContainer.GetServiceProxyClassFactory()">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;public IProxyFactory GetServiceProxyClassFactory()&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      {&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;return proxyFactory ?? (proxyFactory =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; overrides.ServiceProxyClassFactory != null
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;? overrides.ServiceProxyClassFactory(this)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;: <font color="#0000ff">new</font>&#160; <b><font color="#006666">ProxyFactory</font></b>(<font color="#006600">GetServiceDescriptionBuilder</font>(), <font color="#006600">GetCodecContainer</font>()));&#160;&#160;&#160;&#160;&#160; &#160;
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
<node CREATED="1419733537319" ID="ID_952732808" MODIFIED="1419733554148" TEXT="&#x5b8c;&#x5168;&#x540c;&#x4e8e;RpcClient&#x7684;&#x4e00;&#x5957;"/>
</node>
<node COLOR="#006666" CREATED="1419745518536" ID="ID_1944097997" MODIFIED="1419745610478" TEXT="inherit from ">
<font BOLD="true" NAME="SansSerif" SIZE="12"/>
<node CREATED="1419745541064" ID="ID_411254656" LINK="#ID_102480876" MODIFIED="1419750721752" TEXT="RpcClientComponentContainer">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      public class RpcClientComponentContainer : IRpcClientComponentContainer
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IRpcClient client;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly RpcClientComponentOverrides overrides;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private IServiceDescriptionBuilder serviceDescriptionBuilder;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private ICodecContainer codecContainer;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private IRequestSenderContainer requestSenderContainer;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private IOutgoingRequestProcessor outgoingRequestProcessor;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private IProxyFactory proxyFactory;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private IProxyContainer proxyContainer;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public RpcClientComponentContainer(<font color="#0000ff">IRpcClient</font>&#160; <b><font color="#6600cc">client</font></b>, RpcClientComponentOverrides <b><font color="#6600cc">overrides</font></b>)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.client = client;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.overrides = overrides;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IRpcClient Client { get { return client; } }
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IServiceDescriptionBuilder <font color="#006666">GetServiceDescriptionBuilder</font>()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return serviceDescriptionBuilder ?? (serviceDescriptionBuilder = new ServiceDescriptionBuilder(new <b><font color="#006666">MethodDescriptionBuilder</font></b>()));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public ICodecContainer <font color="#006666">GetCodecContainer</font>()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return codecContainer ?? (codecContainer =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;overrides.CodecContainer != null
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;? overrides.CodecContainer(this)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;: new <b><font color="#006666">CodecContainer</font></b>());
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IRequestSenderContainer <font color="#006666">GetRequestSenderContainer</font>()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return requestSenderContainer ?? (requestSenderContainer =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; overrides.RequestSenderContainer != null
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;? overrides.RequestSenderContainer(this)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;: new <b><font color="#006666">RequestSenderContainer</font></b>());
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IOutgoingRequestProcessor <font color="#006666">GetOutgoingMethodCallProcessor</font>()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return outgoingRequestProcessor ?? (outgoingRequestProcessor =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; overrides.OutgoingMethodCallProcessor != null
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;? overrides.OutgoingMethodCallProcessor(this)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;: new <b><font color="#006666">OutgoingRequestProcessor</font></b>(client.Topology, GetRequestSenderContainer(), GetCodecContainer()));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IProxyFactory <font color="#006666">GetServiceProxyClassFactory</font>()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return proxyFactory ?? (proxyFactory =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; overrides.ServiceProxyClassFactory != null
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;? overrides.ServiceProxyClassFactory(this)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;: new <b><font color="#006666">ProxyFactory</font></b>(GetServiceDescriptionBuilder(), GetCodecContainer()));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IProxyContainer <font color="#006666">GetIServiceProxyContainer</font>()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return proxyContainer ?? (proxyContainer =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; overrides.ServiceProxyContainer != null
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;? overrides.ServiceProxyContainer(this)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;: new <b><font color="#006666">ProxyContainer</font></b>(GetOutgoingMethodCallProcessor(), GetServiceProxyClassFactory()));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1419745627416" ID="ID_1206818517" MODIFIED="1419750726823" TEXT="IRpcClientServerComponentContainer">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;&#160;&#160;&#160;public interface IRpcClientServerComponentContainer : IRpcClientComponentContainer
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;IRpcClientServer ClientServer { get; }
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;ILogger GetLogger();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;IServiceImplementationContainer <font color="#006666">GetServiceImplementationContainer</font>();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;IServiceImplementationFactory <font color="#006666">GetServiceImplementationFactory</font>();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;IHandlerFactory <font color="#0000ff">GetServiceMethodHandlerFactory</font>();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;IHandlerContainer <font color="#0000ff">GetServiceMethodHandlerContainer</font>();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;IIncomingRequestProcessor <font color="#6600cc">Get</font><b><font color="#009900">Incoming</font></b><font color="#6600cc">RequestProcessor</font>();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;IRequestReceiverContainer <font color="#6600cc">GetRequest</font><b><font color="#009900">Receiver</font></b><font color="#6600cc">Container</font>();
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
<node COLOR="#006666" CREATED="1419745635143" ID="ID_1983780056" MODIFIED="1419745755277" TEXT="inherit from ">
<font BOLD="true" NAME="SansSerif" SIZE="12"/>
<node CREATED="1419745774984" ID="ID_102480876" MODIFIED="1419746301044" TEXT="IRpcClientComponentContainer">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;&#160;&#160;&#160;&#160;public interface IRpcClientComponentContainer
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;IRpcClient Client { get; }
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;IServiceDescriptionBuilder <font color="#006666">GetServiceDescriptionBuilder</font>();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;ICodecContainer <font color="#006666">GetCodecContainer</font>();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;IRequestSenderContainer <b><font color="#6600cc">GetRequest</font><font color="#009900">Sender</font><font color="#6600cc">Container</font></b>();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;IOutgoingRequestProcessor <b><font color="#6600cc">Get</font><font color="#009900">OutgoingMethod</font><font color="#6600cc">CallProcessor</font></b>();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;IProxyFactory <font color="#0000ff">GetServiceProxyClassFactory</font>();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;IProxyContainer <font color="#0000ff">GetIServiceProxyContainer</font>();
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
</node>
</node>
<node CREATED="1419585051089" FOLDED="true" ID="ID_880207697" LINK="#ID_1735481938" MODIFIED="1419754317355" TEXT="componentContainer.GetServiceImplementationContainer()">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;public IServiceImplementationContainer GetServiceImplementationContainer()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return serviceImplementationContainer ?? (serviceImplementationContainer =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; overrides.ServiceImplementationContainer != null
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;? overrides.ServiceImplementationContainer(this)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;: new ServiceImplementationContainer(<font color="#ff6600"><b>GetServiceImplementationFactory()</b></font>));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
<linktarget COLOR="#b0b0b0" DESTINATION="ID_880207697" ENDARROW="Default" ENDINCLINATION="128;0;" ID="Arrow_ID_251708922" SOURCE="ID_660433953" STARTARROW="None" STARTINCLINATION="-27;18;"/>
<icon BUILTIN="full-1"/>
<node BACKGROUND_COLOR="#ccff00" CREATED="1419585155969" ID="ID_1666347409" MODIFIED="1419754239666" TEXT="serviceImplementationContainer">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      public class ServiceImplementationContainer : IServiceImplementationContainer
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;<i>&#160;class <font color="#0000ff"><b>ImplementationSet</b></font>&#160;</i>
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{ </i>
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly string serviceName; </i>
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IServiceImplementationFactory serviceImplementationFactory; </i>
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly ConcurrentDictionary&lt;<font color="#009966">ScopeKey</font>, <font color="#009966">Lazy&lt;ServiceImplementationInfo&gt;</font>&gt; <font color="#009966"><b>scopedImplementations</b></font>; </i>
    </p>
    <p>
      
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public ImplementationSet(string serviceName, IServiceImplementationFactory serviceImplementationFactory) </i>
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{ </i>
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.serviceName = serviceName; </i>
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.serviceImplementationFactory = serviceImplementationFactory; </i>
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;scopedImplementations = new ConcurrentDictionary&lt;ScopeKey, Lazy&lt;ServiceImplementationInfo&gt;&gt;(); </i>
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;} </i>
    </p>
    <p>
      
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private ServiceImplementationInfo <font color="#009966"><b>CreateNew</b></font>(string scope) </i>
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{ </i>
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return serviceImplementationFactory.<font color="#009966">CreateImplementation</font>(serviceName, scope); </i>
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;} </i>
    </p>
    <p>
      
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public ServiceImplementationInfo <font color="#ff6600"><b>GetForScope</b></font>(string scope) </i>
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{ </i>
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return scopedImplementations.GetOrAdd(new ScopeKey(scope), s =&gt; new Lazy&lt;<font color="#0000cc">ServiceImplementationInfo</font>&gt;(() =&gt; <font color="#009966"><b>CreateNew</b></font>(s.Scope), true)).Value; </i>
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;} </i>
    </p>
    <p>
      
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IEnumerable&lt;string&gt; <font color="#ff6600"><b>GetInitializedScopes</b></font>() </i>
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{ </i>
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return scopedImplementations.Keys.Select(x =&gt; x.Scope); </i>
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;} </i>
    </p>
    <p>
      <i>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}</i>
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IServiceImplementationFactory <font color="#ff0000"><b>serviceImplementationFactory</b></font>;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly ConcurrentDictionary&lt;string, ImplementationSet&gt; <font color="#006666"><b>implementations</b></font>;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public ServiceImplementationContainer(IServiceImplementationFactory <font color="#6600cc">serviceImplementationFactory</font>)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.<font color="#ff0000"><b>serviceImplementationFactory </b></font>= serviceImplementationFactory;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<font color="#006666"><b>implementations</b></font>&#160; = new ConcurrentDictionary&lt;string, ImplementationSet&gt;();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public ServiceImplementationInfo <font color="#006666"><b>GetImplementation</b></font>(string <font color="#0000ff">serviceName</font>, string <font color="#0000ff">scope</font>)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (serviceName == null)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;throw new InvalidPathException();
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var set = implementations.GetOrAdd(serviceName, x =&gt; new ImplementationSet(x, serviceImplementationFactory));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return set.GetForScope(scope);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IEnumerable&lt;string&gt; GetInitializedScopesFor(string serviceName)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (serviceName == null)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;throw new InvalidPathException();
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;ImplementationSet set;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (!implementations.TryGetValue(serviceName, out set))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (!serviceImplementationFactory.CanCreate(serviceName))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;throw new ServiceNotFoundException();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return Enumerable.Empty&lt;string&gt;();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return set.GetInitializedScopes();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
<linktarget COLOR="#b0b0b0" DESTINATION="ID_1666347409" ENDARROW="Default" ENDINCLINATION="141;23;" ID="Arrow_ID_941850858" SOURCE="ID_1274968434" STARTARROW="None" STARTINCLINATION="-111;71;"/>
<node CREATED="1419585173137" ID="ID_768800" MODIFIED="1419731589164" TEXT="IServiceImplementationContainer">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      public interface IServiceImplementationContainer&#160;&#160;&#160;
    </p>
    <p>
      {&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;<font color="#006666">ServiceImplementationInfo</font>&#160;<font color="#6600cc">GetImplementation</font>(string serviceName, string scope);&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;IEnumerable&lt;string&gt; <font color="#0000ff">GetInitializedScopesFor</font>(string serviceName);&#160;&#160;&#160;
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
<node CREATED="1419585348833" ID="ID_545583851" MODIFIED="1419731589179" TEXT="ServiceImplementationInfo">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      public struct ServiceImplementationInfo&#160;&#160;&#160;
    </p>
    <p>
      {&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;public readonly <font color="#006666">ServiceDescription</font>&#160;Description;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;public readonly object Implementation;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;public ServiceImplementationInfo(<font color="#006666">ServiceDescription</font>&#160; description, <b><font color="#0000ff">object</font></b>&#160;implementation)&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;{&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;Description = description;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;<font color="#0000ff">Implementation</font>&#160;= implementation;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;}&#160;&#160;&#160;
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
<node CREATED="1419585451921" ID="ID_301060837" MODIFIED="1419585656604" TEXT="ServiceDescription">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;&#160;&#160;&#160;public class ServiceDescription
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public Type Type { get; set; }
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public string Name { get; set; }
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IReadOnlyList&lt;<font color="#006666">ServiceDescription</font>&gt; <font color="#0000cc"><b>Subservices</b></font>&#160;{ get; set; }
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IReadOnlyList&lt;<font color="#6600cc">MethodDescription</font>&gt; Methods { get; set; }
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
<node CREATED="1419585560752" ID="ID_1113787886" MODIFIED="1419585629387" TEXT="MethodDescription">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;&#160;&#160;&#160;public class MethodDescription
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public <font color="#006666">MethodRemotingType</font>&#160; RemotingType { get; set; }
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public <font color="#0000ff">MethodInfo</font>&#160; MethodInfo { get; set; }
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public <font color="#006666">Type</font>&#160; ReturnType { get; set; }
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public string Name { get; set; }
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IReadOnlyList&lt;<font color="#006666">GenericParameterDescription</font>&gt; GenericParameters { get; set; }
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IReadOnlyList&lt;<font color="#6600ff">MethodParameterDescription</font>&gt; Parameters { get; set; }
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
</node>
</node>
<node CREATED="1419733575943" ID="ID_1319699372" MODIFIED="1419733592609" TEXT="&#x5b57;&#x9762;&#x610f;&#x4e49;&#xff1a;&#x771f;&#x6b63;&#x7684;&#x670d;&#x52a1;&#x5b9e;&#x73b0;&#x63a5;&#x53e3;"/>
</node>
<node CREATED="1419585797952" FOLDED="true" ID="ID_705362828" LINK="#ID_1592083148" MODIFIED="1419744931306" TEXT="componentContainer.GetIServiceProxyContainer()">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      public IProxyContainer GetIServiceProxyContainer()&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      {&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;return proxyContainer ?? (proxyContainer =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; overrides.ServiceProxyContainer != null
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;? overrides.ServiceProxyContainer(this)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;: <font color="#0000ff">new</font>&#160; <b><font color="#006666">ProxyContainer</font></b>(<font color="#006600">GetOutgoingMethodCallProcessor</font>(), <font color="#006600">GetServiceProxyClassFactory</font>()));&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
<icon BUILTIN="full-1"/>
<node BACKGROUND_COLOR="#ccff00" CREATED="1419732760775" ID="ID_164331397" MODIFIED="1419744839878" TEXT="proxyContainer">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;&#160;&#160;&#160;public class ProxyContainer : IProxyContainer
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;#region Proxy Set
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private class <b><font color="#006666">ProxySet</font></b>&lt;T&gt; where T : class
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IOutgoingRequestProcessor processor;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly Func&lt;IOutgoingRequestProcessor, string, TimeoutSettings, T&gt; constructor;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly ConcurrentDictionary&lt;ProxyKey, T&gt; scopedProxies;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public ProxySet(IOutgoingRequestProcessor <b><font color="#006666">processor</font></b>, Func&lt;IOutgoingRequestProcessor, string, TimeoutSettings, T&gt; <b><font color="#006666">constructor</font></b>)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.processor = processor;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.constructor = constructor;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;scopedProxies = new ConcurrentDictionary&lt;ProxyKey, T&gt;();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public T GetForScope(string scope, TimeoutSettings timeoutSettings)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return scopedProxies.GetOrAdd(new ProxyKey(scope, timeoutSettings), s =&gt; constructor(processor, scope, timeoutSettings));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;#endregion
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IOutgoingRequestProcessor processor;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IProxyFactory factory;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly ConcurrentDictionary&lt;Type, object&gt; proxySets;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public ProxyContainer(IOutgoingRequestProcessor <b><font color="#006600">processor</font></b>, IProxyFactory <b><font color="#006600">factory</font></b>)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.processor = processor;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.factory = factory;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;proxySets = new ConcurrentDictionary&lt;Type, object&gt;();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public T GetProxy&lt;T&gt;(string scope, TimeoutSettings timeoutSettings) where T : class
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var set = (ProxySet&lt;T&gt;)proxySets.GetOrAdd(typeof(T), t =&gt; new ProxySet&lt;T&gt;(<b><font color="#006666">processor</font></b>, <b><font color="#006666">factory.CreateProxy&lt;T&gt;()</font></b>));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return set.GetForScope(scope, timeoutSettings);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1419733595352" ID="ID_1503076410" MODIFIED="1419733632724" TEXT="&#x5b57;&#x9762;&#x610f;&#x4e49;&#xff1a;&#x63a5;&#x6536;&#x5ba2;&#x6237;&#x7aef;&#x6570;&#x636e;&#x7684;&#x4ee3;&#x7406;&#x63a5;&#x53e3;&#xff0c;&#x540c;&#x4e8e;&#x670d;&#x52a1;&#x5b9e;&#x73b0;&#x63a5;&#x53e3;"/>
</node>
<node CREATED="1419581051936" ID="ID_1802183036" MODIFIED="1419755070617" TEXT="componentContainer.GetRequestReceiverContainer().GetReceiver()&#x65b9;&#x6cd5;">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;public IRequestReceiverContainer GetRequestReceiverContainer()
    </p>
    <p>
      &#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return requestReceiverContainer ?? (requestReceiverContainer =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;overrides.RequestReceiverContainer != null
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;? overrides.RequestReceiverContainer(this): new <font color="#6600ff">RequestReceiverContainer</font>(<font color="#ff6600">GetIncomingRequestProcessor</font>(), GetLogger()));
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
<node CREATED="1419750816921" ID="ID_660433953" MODIFIED="1419753671295" TEXT="componetContainer.GetIncomingRequestProcessor()">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IIncomingRequestProcessor GetIncomingRequestProcessor()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return incomingRequestProcessor ?? (incomingRequestProcessor =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; overrides.IncomingRequestProcessor != null
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;? overrides.IncomingRequestProcessor(this)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;: <font color="#0000ff">new</font>&#160;<b><font color="#006666">&#160; IncomingRequestProcessor</font></b>(GetLogger(), <font color="#6600cc">GetServiceImplementationContainer()</font>,<font color="#6600cc">GetServiceMethodHandlerContainer()</font>, GetCodecContainer()));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
<arrowlink DESTINATION="ID_880207697" ENDARROW="Default" ENDINCLINATION="128;0;" ID="Arrow_ID_251708922" STARTARROW="None" STARTINCLINATION="-27;18;"/>
<node CREATED="1419752885288" ID="ID_709680056" MODIFIED="1419753597309" TEXT="componentContainer.GetServiceMethodHandlerContainer()">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      public IHandlerContainer GetServiceMethodHandlerContainer()&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      {&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;return handlerContainer ?? (handlerContainer =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; overrides.ServiceMethodHandlerContainer != null
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;? overrides.ServiceMethodHandlerContainer(this)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;: <font color="#0000ff">new&#160; </font><font color="#006666">HandlerContainer</font>(<b><font color="#009900">GetServiceMethodHandlerFactory</font></b><font color="#009900">()</font>));&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
<node CREATED="1419753111736" ID="ID_66557887" MODIFIED="1419753285851" TEXT="componetContainer.GetServiceMethodHandlerFactory()">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      public IHandlerFactory GetServiceMethodHandlerFactory()&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      {&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;return handlerFactory ?? (handlerFactory =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; overrides.ServiceMethodHandlerFactory != null
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;? overrides.ServiceMethodHandlerFactory(this)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;: <font color="#0000ff">new</font>&#160; <b><font color="#006666">HandlerFactory</font></b>(<b><font color="#009900">GetCodecContainer</font></b>(), <b><font color="#009900">GetServiceMethodDelegateFactory</font></b>())); &#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
<node BACKGROUND_COLOR="#ccff00" CREATED="1419753404793" ID="ID_1559175674" MODIFIED="1419753490718" TEXT="componentContainer.GetServiceMethodDelegateFactory()">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      public IRawHandlerFactory GetServiceMethodDelegateFactory()&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      {&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;return rawHandlerFactory ?? (rawHandlerFactory =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; overrides.ServiceMethodDelegateFactory != null
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;? overrides.ServiceMethodDelegateFactory(this)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;: <font color="#0000ff">new</font>&#160;<b><font color="#009900">RawHandlerFactory</font></b>(<font color="#006666">GetCodecContainer</font>()));&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
<node BACKGROUND_COLOR="#ffcccc" CREATED="1419756309209" ID="ID_667929932" MODIFIED="1419758028671" TEXT="RawHandlerFactory">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      public class RawHandlerFactory : IRawHandlerFactory
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly ICodecContainer <font color="#006600">codecContainer</font>;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly ModuleBuilder moduleBuilder;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private int classNameDisambiguator;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public RawHandlerFactory(ICodecContainer <b><font color="#006600">codecContainer</font></b>)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<font color="#006600">this.codecContainer</font>&#160; = <b><font color="#006600">codecContainer</font></b>;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var appDomain = AppDomain.CurrentDomain;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var assemblyBuilder = appDomain.DefineDynamicAssembly(new AssemblyName(&quot;SharpRpcHandlers&quot;), AssemblyBuilderAccess.Run);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;moduleBuilder = assemblyBuilder.DefineDynamicModule(&quot;SharpRpcHandlerModule&quot;);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;// ReSharper disable UnusedMember.Global
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public static Task&lt;byte[]&gt; ToEmptyByteArrayTask(Task task)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return task.ContinueWith(t =&gt; new byte[0]);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;// ReSharper restore UnusedMember.Global
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static readonly MethodInfo ToEmptyByteArrayTaskMethod = typeof(RawHandlerFactory).GetMethod(&quot;ToEmptyByteArrayTask&quot;);
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public <font color="#6600cc">Func&lt;Type[], <b>IHandler</b>&gt;</font>&#160; <b><font color="#009900">CreateGenericClass</font></b>(IReadOnlyList&lt;ServiceDescription&gt; serviceDescriptionChain, MethodDescription methodDescription, ServicePath path)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var type = CreateType(serviceDescriptionChain, methodDescription, path);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (type.IsGenericType)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return t =&gt; (IHandler)Activator.CreateInstance(type.MakeGenericType(t), codecContainer);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return t =&gt; (IHandler)Activator.CreateInstance(type, codecContainer);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private Type CreateType(IReadOnlyList&lt;ServiceDescription&gt; serviceDescriptionChain, MethodDescription methodDescription, ServicePath path)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;...
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static void CreateMethodDelegate(HandlerClassBuildingContext classContext)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;...
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static void EmitProcessAndEncodeDirect(IEmittingContext emittingContext, HandlerParameterCodec[] responseParameterCodecs, Type retvalType)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;...
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static void EmitProcessAndEncodeAsyncVoid(IEmittingContext emittingContext)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;...
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static void EmitProcessAndEncodeAsyncWithRetval(HandlerClassBuildingContext classContext, IEmittingContext emittingContext, Type pureRetvalType)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;...
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static MethodBuilder CreateEncodeDeferredMethod(HandlerClassBuildingContext classContext, Type pureRetvalType)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;...
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static void EmitEncodeDirect(IEmittingContext emittingContext, HandlerParameterCodec[] responseParameterCodecs, Type retvalType)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;...
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static void EmitAddIf(MyILGenerator il, ref bool haveSizeOnStack)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;...
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static void CreateConstructor(HandlerClassBuildingContext classContext)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;...
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
<node CREATED="1419758363592" ID="ID_683279556" MODIFIED="1419758937786" TEXT="CreateMethodDelegate&#x521b;&#x5efa;&#x540d;&#x4e3a;Handle&#x7684;&#x65b9;&#x6cd5;">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      private static void CreateMethodDelegate(HandlerClassBuildingContext classContext)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;const int <b><font color="#ff6600">implementationArgIndex</font></b>&#160;= 1;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;const int dataArgIndex = 2;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;const int offsetArgIndex = 3;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var methodBuilder = <font color="#009900">classContext.Builder.DefineMethod</font>(&quot;<b><font color="#6600cc">Handle</font></b>&quot;,
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;MethodAttributes.Public | MethodAttributes.Final | MethodAttributes.HideBySig |
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;MethodAttributes.NewSlot | MethodAttributes.Virtual,
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<font color="#009900">typeof(Task&lt;byte[]&gt;)</font>, new[] { <font color="#006666">typeof(object)</font>, <font color="#006666">typeof(byte[])</font>, <font color="#006666">typeof(int)</font>&#160;});
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var il = new MyILGenerator(methodBuilder.GetILGenerator());
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var emittingContext = new HandlerMethodEmittingContext(il, classContext.Fields);
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var serviceDescriptionChain = classContext.ServiceDescriptionChain;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ldarg(<b><font color="#ff6600">implementationArgIndex</font></b>);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;// stack_0 = (TServiceImplementation) arg_1
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Castclass(serviceDescriptionChain.First().Type); <font color="#009900">//&#33719;&#21462;Implementation&#23545;&#35937;</font>
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;for (int i = 0; i &lt; serviceDescriptionChain.Count - 1; i++)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var current = serviceDescriptionChain[i];
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var next = serviceDescriptionChain[i + 1];
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; il.Callvirt(current.Type.GetProperty(next.Name).GetGetMethod());&#160;&#160;&#160;&#160;// stack_0 = stack_0.Property
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var methodDescription = classContext.MethodDescription;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var genericArgumentMap = methodDescription.GenericParameters
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;.Zip(classContext.GenericTypeParameterBuilders, (p, a) =&gt; new KeyValuePair&lt;string, Type&gt;(p.Name, a))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;.ToDictionary(x =&gt; x.Key, x =&gt; x.Value);
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var parameterDescriptions = methodDescription.Parameters.Select(x =&gt; x.DeepSubstituteGenerics(genericArgumentMap)).ToArray();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var retvalType = methodDescription.ReturnType.DeepSubstituteGenerics(genericArgumentMap);
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var allParameterCodecs = parameterDescriptions.Select((x, i) =&gt; new HandlerParameterCodec(emittingContext, x)).ToArray();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var <b><font color="#009999">requestParameterCodecs</font></b>&#160; = allParameterCodecs.Where(x =&gt; x.IsRequestParameter).ToArray();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var <b><font color="#009999">responseParameterCodecs</font></b>&#160;= allParameterCodecs.Where(x =&gt; x.IsResponseParameter).ToArray();
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<font color="#666600">&#160;&#160;</font><font color="#006666">if (requestParameterCodecs.Any()) </font>
    </p>
    <p>
      <font color="#006666">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{ </font>
    </p>
    <p>
      <font color="#006666">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ldarg(dataArgIndex);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; // remainingBytes = dataArray.Length - offset </font>
    </p>
    <p>
      <font color="#006666">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ldlen(); </font>
    </p>
    <p>
      <font color="#006666">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ldarg(offsetArgIndex); </font>
    </p>
    <p>
      <font color="#006666">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Sub(); </font>
    </p>
    <p>
      <font color="#006666">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Stloc(emittingContext.RemainingBytesVar); </font>
    </p>
    <p>
      <font color="#006666">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var pinnedVar = il.PinArray(typeof(byte), 2);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;// var pinned dataPointer = pin(dataArray) </font>
    </p>
    <p>
      <font color="#006666">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ldloc(pinnedVar);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; // data = dataPointer + offset </font>
    </p>
    <p>
      <font color="#006666">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ldarg(offsetArgIndex); </font>
    </p>
    <p>
      <font color="#006666">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Add(); </font>
    </p>
    <p>
      <font color="#006666">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Stloc(emittingContext.DataPointerVar); </font>
    </p>
    <p>
      <font color="#006666">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;} </font><font color="#009900">//&#23558;&#35831;&#27714;&#25968;&#25454;&#23383;&#33410;&#25968;&#32452;byte[]&#23384;&#20837;dataPointerVar</font>
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <font color="#009900">//&#35299;&#26512;&#20855;&#20307;&#30340;&#26041;&#27861;&#21442;&#25968;</font>
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<font color="#ff6600">&#160;&#160;<b>foreach (var codec in allParameterCodecs) </b></font>
    </p>
    <p>
      <b><font color="#ff6600">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;codec.EmitDecodeAndPrepare();</font></b>
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;// ReSharper disable CoVariantArrayConversion
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<b><font color="#cc00cc">&#160;&#160;var resolvedMethodInfo = classContext.GenericTypeParameterBuilders.Any() </font></b>
    </p>
    <p>
      <b><font color="#cc00cc">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;? methodDescription.MethodInfo.MakeGenericMethod(classContext.GenericTypeParameterBuilders) </font></b>
    </p>
    <p>
      <b><font color="#cc00cc">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;: methodDescription.MethodInfo; </font></b>
    </p>
    <p>
      <b><font color="#cc00cc">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Callvirt(resolvedMethodInfo);&#160;&#160;</font></b>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <font color="#009900">// stack_0 = stack_0.Method(stack_1, stack_2, ...)&#65292;&#35843;&#29992;&#30495;&#23454;&#30340;&#26381;&#21153;&#26041;&#27861;</font>
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;// ReSharper restore CoVariantArrayConversion
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;switch (methodDescription.RemotingType)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;case MethodRemotingType.Direct:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<font color="#0000ff">EmitProcessAndEncodeDirect</font>(emittingContext, <b><font color="#009999">responseParameterCodecs</font></b>, retvalType);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;break;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;case MethodRemotingType.AsyncVoid:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<font color="#0000ff">EmitProcessAndEncodeAsyncVoid</font>(emittingContext);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;break;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;case MethodRemotingType.AsyncWithRetval:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<font color="#0000ff">EmitProcessAndEncodeAsyncWithRetval</font>(classContext, emittingContext, retvalType.GetGenericArguments()[0]);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;break;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;default:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;throw new ArgumentOutOfRangeException();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ret();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
</node>
<node CREATED="1419757555976" ID="ID_1687307908" MODIFIED="1419757789040" TEXT="HandlerFactory">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;&#160;&#160;&#160;public class HandlerFactory : IHandlerFactory
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly ICodecContainer codecContainer;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IRawHandlerFactory rawHandlerFactory;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public HandlerFactory(ICodecContainer <font color="#006666">codecContainer</font>, IRawHandlerFactory <font color="#006666">rawHandlerFactory</font>)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.codecContainer = <font color="#006666">codecContainer</font>;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.rawHandlerFactory = <font color="#006666">rawHandlerFactory</font>;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IHandler <b><font color="#009900">CreateHandler</font></b>(ServiceDescription rootDescription, ServicePath path)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var <font color="#009900">serviceDescription</font><font color="#009999">Chain</font>&#160; = CreateServiceDescriptionChain(rootDescription, path);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var<font color="#009900">&#160; methodDescription </font>= GetMethodDescription(serviceDescriptionChain, path);
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return methodDescription.GenericParameters.Any()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;? <font color="#0000ff">new</font>&#160; <b><font color="#006666">GenericHandler</font></b>(codecContainer, rawHandlerFactory, serviceDescriptionChain, methodDescription, path)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;: <b><font color="#006600">rawHandlerFactory.CreateGenericClass</font></b>(serviceDescriptionChain, methodDescription, path)(null);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static List&lt;ServiceDescription&gt; CreateServiceDescriptionChain(ServiceDescription rootDescription, ServicePath path)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var chain = new List&lt;ServiceDescription&gt;(path.Length - 1);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var currentDescription = rootDescription;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;chain.Add(currentDescription);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;for (int i = 1; i &lt; path.Length - 1; i++)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (!currentDescription.TryGetSubservice(path[i], out currentDescription))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;throw new InvalidPathException();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;chain.Add(currentDescription);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return chain;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static MethodDescription GetMethodDescription(IEnumerable&lt;ServiceDescription&gt; serviceDescriptionChain, ServicePath path)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;MethodDescription methodDescription;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (!serviceDescriptionChain.Last().TryGetMethod(path.MethodName, out methodDescription))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;throw new InvalidPathException();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return methodDescription;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
<node CREATED="1419757807048" ID="ID_254381724" LINK="#ID_667929932" MODIFIED="1419757870072" TEXT="CreateGenericClass&#x6240;&#x521b;&#x5efa;&#x7684;&#x7c7b;&#x4e2d;&#x4e00;&#x5b9a;&#x5305;&#x542b;&#x65b9;&#x6cd5;Handle"/>
</node>
</node>
<node BACKGROUND_COLOR="#ffcccc" CREATED="1419753282233" ID="ID_1842725182" MODIFIED="1419754296424" TEXT="this: IncomingRequestProcessor">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      public class IncomingRequestProcessor : IIncomingRequestProcessor
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IServiceImplementationContainer serviceImplementationContainer;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IHandlerContainer handlerContainer;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IManualCodec&lt;Exception&gt; exceptionCodec;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly ILogger logger;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IncomingRequestProcessor(ILogger <font color="#006666">logger</font>, IServiceImplementationContainer <font color="#009900">serviceImplementationContainer</font>,
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;IHandlerContainer <font color="#006666">handlerContainer</font>, ICodecContainer <font color="#0000ff">codecContainer</font>)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.logger = logger;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.serviceImplementationContainer = serviceImplementationContainer;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.handlerContainer = handlerContainer;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;exceptionCodec = codecContainer.GetManualCodecFor&lt;Exception&gt;();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public <b><font color="#0000ff">async</font></b>&#160;Task&lt;<b><font color="#cc0000">Response</font></b>&gt; <b><font color="#009900">Process</font></b>(Request <b><font color="#cc00cc">request</font></b>)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;try
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;logger.IncomingRequest(request);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var startTime = DateTime.Now;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var <b><font color="#6600cc">implementationInfo</font></b>&#160; = <b><font color="#006666">serviceImplementationContainer.GetImplementation</font></b>(request.Path.ServiceName, request.ServiceScope);
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var <b><font color="#009900">methodHandler</font></b>&#160;= handlerContainer.GetHandler(<font color="#6600cc">implementationInfo.Description</font>, request.Path);
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var <b><font color="#006666">responseData</font></b>&#160; = <b><font color="#0000ff">await</font></b>&#160; <b><font color="#009900">methodHandler.Handle</font></b>(<font color="#6600cc">implementationInfo.Implementation</font>, <b><font color="#cc00cc">request.Data</font></b>, 0);
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var executionTime = DateTime.Now - startTime;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;logger.ProcessedRequestSuccessfully(request, executionTime);
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return <font color="#0000ff">new</font>&#160;<b><font color="#cc0000">Response</font></b>(ResponseStatus.Ok, <b><font color="#006666">responseData</font></b>);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;catch (ServiceNotReadyException)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;logger.ProcessNotReady(request);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return Response.NotReady;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;catch (ServiceNotFoundException)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;logger.ProcessedRequestWithBadStatus(request, ResponseStatus.ServiceNotFound);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return Response.NotFound;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;catch (InvalidPathException)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;logger.ProcessedRequestWithBadStatus(request, ResponseStatus.BadRequest);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return Response.BadRequest;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;catch (InvalidImplementationException)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;logger.ProcessedRequestWithBadStatus(request, ResponseStatus.InvalidImplementation);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return Response.InvalidImplementation;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;catch (Exception ex)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;logger.ProcessedRequestWithException(request, ex);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var responseData = exceptionCodec.EncodeSingle(ex);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return new Response(ResponseStatus.Exception, responseData);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
<node CREATED="1419754091065" ID="ID_1274968434" MODIFIED="1419754239666" TEXT="ServiceImplementationContainer">
<arrowlink DESTINATION="ID_1666347409" ENDARROW="Default" ENDINCLINATION="141;23;" ID="Arrow_ID_941850858" STARTARROW="None" STARTINCLINATION="-111;71;"/>
</node>
<node CREATED="1419754141193" ID="ID_1066779291" LINK="#ID_1687307908" MODIFIED="1419757882601" TEXT="HandlerContainer">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      public class HandlerContainer : IHandlerContainer
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IHandlerFactory factory;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly ConcurrentDictionary&lt;ServicePath, IHandler&gt; handlers;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public HandlerContainer(<font color="#006666">IHandlerFactory</font>&#160; <b><font color="#006666">factory</font></b>)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.factory = factory;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;handlers = new ConcurrentDictionary&lt;ServicePath, IHandler&gt;();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IHandler GetHandler(ServiceDescription serviceDescription, ServicePath path)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return handlers.GetOrAdd(path, p =&gt; <b><font color="#006666">factory.CreateHandler</font></b>(serviceDescription, p));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1419757319432" ID="ID_338072674" MODIFIED="1419757370547" TEXT="IHandler">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;&#160;&#160;&#160;public interface IHandler
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Task&lt;<font color="#cc0000">byte[]</font>&gt; <b><font color="#006600">Handle</font></b>(object <b><font color="#009999">serviceImplementation</font></b>, byte[] <b><font color="#cc0000">data</font></b>, int <font color="#cc0000">offset</font>);
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
<node CREATED="1419579313087" ID="ID_29479737" MODIFIED="1419754489657" TEXT="RequestReceiverContainer">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;&#160;public class RequestReceiverContainer : IRequestReceiverContainer
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IIncomingRequestProcessor requestProcessor;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly ILogger logger;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private HttpRequestReceiver httpReceiver;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public RequestReceiverContainer(IIncomingRequestProcessor <b><font color="#009900">requestProcessor</font></b>, ILogger logger)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.requestProcessor = requestProcessor;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.logger = logger;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public <b><font color="#006666">IRequestReceiver</font></b>&#160; GetReceiver(string protocol)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;switch (protocol)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;case &quot;http&quot;: return httpReceiver ?? (httpReceiver = <font color="#0000ff">new</font>&#160; <b><font color="#006600">HttpRequestReceiver</font></b>(<b><font color="#009900">requestProcessor</font></b>, logger));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;default: throw new NotSupportedException(string.Format(&quot;Protocol '{0}' is not supported&quot;, protocol));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
<node CREATED="1419580692432" ID="ID_1148919951" MODIFIED="1419581503442" TEXT="IincomingRequestProcessor">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;&#160;&#160;&#160;&#160;public <font color="#0000ff">interface</font>&#160;<font color="#006666">IIncomingRequestProcessor</font>
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Task&lt;Response&gt; Process(Request request);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1419585092928" ID="ID_1421156847" MODIFIED="1419585102238" TEXT="GetReceiver()">
<node CREATED="1419754615577" ID="ID_1868582312" MODIFIED="1419754968291" TEXT="IRequestReceiver">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;&#160;&#160;&#160;public interface IRequestReceiver
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;void Start(int port, int threads);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;void Stop();
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
</node>
<node BACKGROUND_COLOR="#ffcccc" CREATED="1419754644953" ID="ID_69621030" LINK="#ID_1842725182" MODIFIED="1419816374209" TEXT="HttpRequestReceiver">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      public class HttpRequestReceiver : IRequestReceiver
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly IIncomingRequestProcessor requestProcessor;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly ILogger logger;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private HttpListener listener;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private Thread listenerThread;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public HttpRequestReceiver(IIncomingRequestProcessor <b><font color="#009900">requestProcessor</font></b>, ILogger logger)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <font color="#009900">this.requestProcessor</font>&#160; = requestProcessor;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;this.logger = logger;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private <font color="#0000ff">async</font>&#160;Task DoWork(HttpListenerContext context)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;try
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Request request;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (<b><font color="#cc0000">TryDecodeRequest</font></b>(context.Request, out request))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var response = <font color="#0000ff">await</font>&#160; <b><font color="#009900">requestProcessor.Process</font></b>(request);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;context.Response.StatusCode = (int)response.Status;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;context.Response.OutputStream.Write(response.Data, 0, response.Data.Length);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;else
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;logger.Error(string.Format(&quot;Failed to decode request '{0}'&quot;, context.Request.Url));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;context.Response.StatusCode = (int)ResponseStatus.BadRequest;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;catch (Exception ex)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;logger.NetworkingException(&quot;Processing a request failed unexpectedly&quot;, ex);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;context.Response.StatusCode = (int)ResponseStatus.InternalServerError;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;finally
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;try
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;context.Response.Close();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;catch (Exception ex)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;logger.NetworkingException(&quot;Closing a response stream failed&quot;, ex);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static bool <font color="#cc0000">TryDecodeRequest</font>(HttpListenerRequest httpWebRequest, out Request request)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;using (var inputStream = httpWebRequest.InputStream)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;ServicePath servicePath;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (!ServicePath.TryParse(httpWebRequest.Url.LocalPath, out servicePath))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;request = null;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return false;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var scope = httpWebRequest.QueryString[&quot;scope&quot;];
    </p>
    <p>
      <b><font color="#009900">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;//&#27809;&#20570;&#20219;&#20309;&#22788;&#29702;&#65292;&#30452;&#25509;&#23558;&#25968;&#25454;&#20132;&#32473;requestProcessor&#30340;Process&#21435;&#22788;&#29702;</font></b>
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var <b><font color="#cc0000">data</font></b>&#160;= inputStream.ReadToEnd(httpWebRequest.ContentLength64);
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;request = new Request(servicePath, scope, data);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return true;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private void DoListen()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;try
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;listener.Start();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;logger.Info(&quot;Listener has started&quot;);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;while (listener.IsListening)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;try
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var context = listener.GetContext();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Task.Run(() =&gt; DoWork(context));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;catch (Exception ex)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (listener != null &amp;&amp; !listener.IsListening)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;logger.Info(&quot;Listener was stopped while getting a context&quot;);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;else
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;logger.NetworkingException(&quot;Listener failed to get a context&quot;, ex);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;catch (Exception ex)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;logger.Fatal(&quot;Listener thread was killed by an exception&quot;, ex);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;logger.Info(&quot;Listener has finished working&quot;);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public void <b><font color="#0000ff">Start</font></b>(int port, int threads)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (listener != null)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;throw new InvalidOperationException(&quot;Trying to start a receiver that is already running&quot;);
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;listener = new HttpListener();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;listener.Prefixes.Add(&quot;http://*:&quot; + port + &quot;/&quot;);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;listenerThread = new Thread(DoListen);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;listenerThread.Start();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public void <b><font color="#0000ff">Stop</font></b>()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;listener.Stop();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;listenerThread.Join();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;listener.Close();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;listener = null;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
<linktarget COLOR="#b0b0b0" DESTINATION="ID_69621030" ENDARROW="Default" ENDINCLINATION="285;115;" ID="Arrow_ID_1137964197" SOURCE="ID_780589851" STARTARROW="None" STARTINCLINATION="27;124;"/>
</node>
</node>
</node>
</node>
</node>
<node BACKGROUND_COLOR="#ffff00" COLOR="#000000" CREATED="1419580453488" ID="ID_780589851" LINK="#ID_69621030" MODIFIED="1419816374208" TEXT="StartHost&#xff1a;&#x6240;&#x6709;RpcClientServer&#x7684;&#x5176;&#x4ed6;&#x63a5;&#x53e3;&#x65b9;&#x6cd5;&#x90fd;&#x662f;&#x56f4;&#x7ed5;&#x7740;&#x5b83;&#x518d;&#x8c03;&#x7528;">
<arrowlink DESTINATION="ID_69621030" ENDARROW="Default" ENDINCLINATION="285;115;" ID="Arrow_ID_1137964197" STARTARROW="None" STARTINCLINATION="27;124;"/>
<icon BUILTIN="messagebox_warning"/>
</node>
<node CREATED="1419584665792" ID="ID_1200574474" MODIFIED="1419584939242" TEXT="GetService&lt;T&gt;">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      public T GetService&lt;T&gt;(string scope, TimeoutSettings timeoutSettings) where T : class
    </p>
    <p>
      {
    </p>
    <p>
      &#160;&#160;&#160;&#160;var serviceName = typeof(T).GetServiceName();
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;if (<font color="#006666"><i><u>topology.GetEndPoint(serviceName, scope) == settings.EndPoint</u></i></font>)
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;var implementation = <font color="#6600ff"><b>serviceImplementationContainer.GetImplementation</b></font>(serviceName, scope).Implementation;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;// todo: notready timeouts
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;return (T)implementation;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;return <font color="#0000ff"><b>proxyContainer.GetProxy</b></font>&lt;T&gt;(scope, timeoutSettings);
    </p>
    <p>
      &#160;&#160;&#160;&#160;
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
<node CREATED="1419584959072" ID="ID_498778296" MODIFIED="1419584976246" TEXT=" serviceImplementationContainer.GetImplementation"/>
<node CREATED="1419584988160" ID="ID_1152707399" MODIFIED="1419584989673" TEXT="proxyContainer.GetProxy&lt;T&gt;"/>
</node>
<node CREATED="1419584693984" ID="ID_1955765740" MODIFIED="1419584702450" TEXT="StopHost"/>
<node CREATED="1419584704336" ID="ID_617734343" MODIFIED="1419584721073" TEXT="GetInitializedScopesFor"/>
</node>
</node>
<node CREATED="1419817806121" ID="ID_506548097" MODIFIED="1420512849424" POSITION="left" TEXT="namespace">
<node CREATED="1419817841209" ID="ID_755497927" MODIFIED="1419817857013" TEXT="SharpRpc.Codecs">
<node CREATED="1419817983096" ID="ID_270426551" MODIFIED="1419819937351" TEXT="CodecContainer">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      public class CodecContainer : ICodecContainer
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly ConcurrentDictionary&lt;Type, IEmittingCodec&gt; <b><font color="#006666">emittingCodecs</font></b>&#160; = new ConcurrentDictionary&lt;Type, IEmittingCodec&gt;();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private readonly ConcurrentDictionary&lt;Type, IManualCodec&gt; <b><font color="#006666">manualCodecs</font></b>&#160; = new ConcurrentDictionary&lt;Type, IManualCodec&gt;();
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IEmittingCodec <b><font color="#006633">GetEmittingCodecFor</font></b>(Type type)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return emittingCodecs.GetOrAdd(type, x =&gt; <b><font color="#660099">CreateCodec</font></b>(type));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public IManualCodec&lt;T&gt; <b><font color="#006633">GetManualCodecFor&lt;T&gt;</font></b>()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return (IManualCodec&lt;T&gt;)manualCodecs.GetOrAdd(typeof(T), x =&gt; <b><font color="#660099">CreateManualCodec</font></b>&lt;T&gt;());
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private IManualCodec&lt;T&gt; <b><font color="#660099">CreateManualCodec</font></b>&lt;T&gt;()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (typeof(T) == typeof(Exception))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return (IManualCodec&lt;T&gt;)new ExceptionCodec(this);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return new ManualCodec&lt;T&gt;(this, <b><font color="#006633">GetEmittingCodecFor</font></b>(typeof(T)));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private IEmittingCodec <b><font color="#660099">CreateCodec</font></b>(Type type)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (TypeIsNativeStructure(type))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return new <b><font color="#663300">NativeStructCodec</font></b>(type);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (type == typeof (string))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return new <b><font color="#663300">StringCodec</font></b>();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (type == typeof(Type))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return new <b><font color="#663300">TypeCodec</font></b>();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (type.IsArray)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (TypeIsNativeStructure(type.GetElementType()))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return new <b><font color="#663300">NativeStructArrayCodec</font></b>(type.GetElementType());
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;else if (type.IsValueType)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return new <b><font color="#663300">ReferenceStructArrayCodec</font></b>(type.GetElementType(), this);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;else
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return new <b><font color="#663300">ClassArrayCodec</font></b>(type.GetElementType(), this);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (type.IsDataContract())
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var members = type.EnumerateDataMembers().ToArray();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (SomeMembersAreIncomplete(members))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;throw new NotSupportedException(string.Format(&quot;Data contract '{0}' is incomplete (it has members with missing getters or setters)&quot;, type.FullName));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (DataContractIsRecursive(type, members))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;throw new NotSupportedException(&quot;Recursive data contracts are not yet supported by SharpRPC&quot;);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return new <b><font color="#663300">DataContractCodec</font></b>(type, this);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (type.IsValueType)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return new <b><font color="#663300">FieldsCodec</font></b>(type, this);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (TypeIsCollection(type))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var elementType = GetCollectionElementType(type);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return new <b><font color="#663300">CollectionCodec</font></b>(type, elementType, this);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;throw new NotSupportedException(string.Format(&quot;Type '{0}' is not supported as an RPC parameter type&quot;, type.FullName));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static bool TypeIsNativeStructure(Type type)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return (type.IsPrimitive &amp;&amp; type != typeof (IntPtr) &amp;&amp; type != typeof (UIntPtr)) ||
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;(type.IsValueType &amp;&amp; type.GetFields(BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;.All(x =&gt; TypeIsNativeStructure(x.FieldType)));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static bool DataContractIsRecursive(Type contractType, IEnumerable&lt;PropertyInfo&gt; members)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return members.Any(x =&gt;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;x.PropertyType == contractType ||
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;x.PropertyType.IsDataContract() &amp;&amp; DataContractIsRecursive(x.PropertyType, x.PropertyType.EnumerateDataMembers()));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static bool SomeMembersAreIncomplete(IEnumerable&lt;PropertyInfo&gt; members)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return members.Any(x =&gt; x.GetGetMethod(true) == null || x.GetSetMethod(true) == null);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static bool SomeFieldsAreNotPublic(Type type)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return type.GetFields(BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic).Any(x =&gt; !x.IsPublic);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static bool SomeMembersArePrivate(IEnumerable&lt;PropertyInfo&gt; members)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return members.Any(x =&gt; x.GetGetMethod() == null || x.GetSetMethod(true) == null);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static bool TypeIsCollection(Type type)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return type.GetInterfaces()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;.Any(x =&gt; x.IsGenericType &amp;&amp; x.GetGenericTypeDefinition() == typeof(ICollection&lt;&gt;));
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;private static Type GetCollectionElementType(Type type)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return type.GetInterfaces()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;.First(x =&gt; x.IsGenericType &amp;&amp; x.GetGenericTypeDefinition() == typeof(ICollection&lt;&gt;))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;.GetGenericArguments()[0];
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
<node CREATED="1419818088952" ID="ID_966237179" MODIFIED="1419818095893" TEXT="inherit from">
<node CREATED="1419818097209" ID="ID_200115496" MODIFIED="1419831503794" TEXT="ICodecContainer">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      public interface ICodecContainer&#160;&#160;&#160;
    </p>
    <p>
      {&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160; <font color="#330066">IEmittingCodec</font>&#160;<b><font color="#006633">GetEmittingCodecFor</font></b>(Type type);&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160; <font color="#330066">IManualCodec&lt;T&gt;</font>&#160;<b><font color="#006633">GetManualCodecFor</font></b>&lt;T&gt;(); &#160;&#160;
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
<node CREATED="1419818174904" ID="ID_1004382713" MODIFIED="1419818282090" TEXT="IEmittingCodec">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;&#160;&#160;&#160;public interface IEmittingCodec : ICodec
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<font color="#330066">bool</font>&#160;<b><font color="#006633">CanBeInlined</font></b>&#160; { get; }
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<font color="#330066">int</font>&#160;<b><font color="#006633">EncodingComplexity</font></b>&#160; { get; }
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;void <b><font color="#006633">EmitCalculateSize</font></b>(IEmittingContext context, Action&lt;MyILGenerator&gt; emitLoad);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;void <b><font color="#006633">EmitEncode</font></b>(IEmittingContext context, Action&lt;MyILGenerator&gt; emitLoad);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;void <b><font color="#006633">EmitDecode</font></b>(IEmittingContext context, bool doNotCheckBounds);
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
<node CREATED="1419818312713" ID="ID_325478724" MODIFIED="1419818370340" TEXT="ICodec">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;public interface ICodec
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160; <font color="#330066">Type</font>&#160;<font color="#006633">Type</font>&#160;{ get; }
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160; <font color="#330066">int?</font>&#160;<font color="#006633">FixedSize</font>&#160; { get; }
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160; <font color="#330066">int?</font>&#160;<font color="#006633">MaxSize</font>&#160;{ get; }
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1419818182601" ID="ID_31794215" MODIFIED="1419818550764" TEXT="IManualCodec&lt;T&gt;">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;&#160;&#160;&#160;public interface <b><font color="#006633">IManualCodec</font></b>&#160;: <b><font color="#006666">ICodec</font></b>
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;public <b><font color="#ff3300">unsafe</font></b>&#160;interface<b><font color="#006633">&#160;IManualCodec&lt;T&gt;</font></b>&#160; : <b><font color="#006666">IManualCodec</font></b>
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<font color="#330066">int</font>&#160;<b><font color="#006633">CalculateSize</font></b>(T value);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;void <b><font color="#006633">Encode</font></b>(ref <font color="#ff3300">byte*</font>&#160;data, T value);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<font color="#330066">T</font>&#160;<b><font color="#006633">Decode</font></b>(ref <font color="#ff3300">byte*</font>&#160;data, ref int remainingBytes, bool doNotCheckBounds);
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
<node CREATED="1419820031768" ID="ID_418329397" MODIFIED="1419997960904" TEXT="&#x51e0;&#x79cd;IEmittingCodec&#x7684;&#x5b9e;&#x73b0;">
<node CREATED="1419820164953" ID="ID_928569642" MODIFIED="1419845121442" TEXT="StringCodecBase">
<font BOLD="true" NAME="SansSerif" SIZE="12"/>
<node CREATED="1419820364728" ID="ID_521604845" MODIFIED="1419901774111" TEXT="EmitCalculateSize"/>
<node CREATED="1419831395065" ID="ID_916197659" MODIFIED="1419901777657" TEXT="EmitEncode"/>
<node CREATED="1419831400826" ID="ID_1875811135" MODIFIED="1419841437529" TEXT="EmitDecode">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;public void EmitDecode(IEmittingContext <b><font color="#ff3300">context</font></b>, bool doNotCheckBounds)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var il = context.IL;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var endOfSubmethodLabel = il.DefineLabel();
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (!doNotCheckBounds)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var canReadSizeLabel = il.DefineLabel();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ldloc(<font color="#ff3300">context.RemainingBytesVar</font>);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;// if (remainingBytes &gt;= sizeof(int)) <font color="#009900">&#38750;&#24120;&#31616;&#21333;&#30340;&#26816;&#26597;&#26159;&#21542;&#26377;&#25968;&#25454;</font>
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ldc_I4(sizeof(int));&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;//&#160;&#160;&#160;&#160;&#160;goto canReadSizeLabel
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<b><font color="#009999">il.Bge</font></b>(canReadSizeLabel);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <font color="#009900">//<b>OpCodes.Bge</b>,&#22914;&#26524;&#31532;&#19968;&#25805;&#20316;&#25968;&#22823;&#20110;&#31561;&#20110;&#31532;&#20108;&#20010;&#25805;&#20316;&#25968;&#25104;&#31435;&#65292;&#21017;&#36339;&#21040;&#25351;&#23450;&#30340;label</font>
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.ThrowUnexpectedEndException();&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;// throw new InvalidDataException(&quot;...&quot;)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.MarkLabel(canReadSizeLabel);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;// label canReadSizeLabel
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ldloc(<font color="#ff3300">context.DataPointerVar</font>);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;// stack_0 = *(int*) data
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ldind_I4();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var tempInteger = context.GetSharedVariable&lt;int&gt;(&quot;tempInteger&quot;);// var tempInteger = stack_0
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Stloc(tempInteger);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.IncreasePointer(context.DataPointerVar, sizeof(int));&#160;&#160;&#160;&#160; &#160;&#160;&#160;// data += sizeof(int) <b><font color="#009999">&#31227;&#21160;&#25351;&#38024;</font></b>
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.DecreaseInteger(context.RemainingBytesVar, sizeof(int));&#160; &#160;&#160;&#160;// remainingBytes -= sizeof(int)&#160;<b><font color="#009999">&#20462;&#27491;&#24453;&#22788;&#29702;&#23383;&#33410;&#25968;</font></b>
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (canBeNull)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var strIsNotNullLabel = il.DefineLabel();
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ldloc(tempInteger);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;// if (tempInteger != -1)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ldc_I4(-1);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;//&#160;&#160;&#160;&#160;&#160;goto strIsNotNullLabel
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<b><font color="#009999">il.Bne_Un</font></b>(strIsNotNullLabel);
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;// String is null branch
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ldnull();&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;// stack_0 = null
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<b><font color="#009999">&#160;il.Br</font></b>(endOfSubmethodLabel);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;// goto endOfSubmethodLabel
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;// String is not null branch
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.MarkLabel(strIsNotNullLabel);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;// label strIsNotNullLabel
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if (!doNotCheckBounds)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var canReadDataLabel = il.DefineLabel();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ldloc(context.RemainingBytesVar);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;// if (remainingBytes &gt;= tempInteger)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ldloc(tempInteger);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;//&#160;&#160;&#160;&#160;&#160;goto canReadDataLabel
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Bge(canReadDataLabel);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.ThrowUnexpectedEndException();&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;// throw new InvalidDataException(&quot;...&quot;)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.MarkLabel(canReadDataLabel);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;// label canReadDataLabel
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ldloc(context.DataPointerVar);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;// stack_0 = data
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ldc_I4(0);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;// stack_1 = 0
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ldloc(tempInteger);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;// stack_2 = tempInteger &gt;&gt; 1
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Ldc_I4(1);
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Shr();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.Newobj(NewString);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;//<b><font color="#009900">&#160;stack_0 = new string(stack_0, stack_1, stack_2),stack_2&#20026;&#23383;&#31526;&#25968;&#65292;string&#25552;&#21462;&#20250;&#25353;&#29031;&#20004;&#20010;&#23383;&#33410;&#19968;&#20010;&#23383;&#31526;&#36827;&#34892;&#29983;&#25104;&#22788;&#29702;</font></b>
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;EmitParseFromString(il);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;<b>&#160;&#160;<font color="#009900">// stack_0 = Parse(stack_0)&#65292;&#38500;&#38750;&#26377;&#39069;&#22806;&#19994;&#21153;&#36923;&#36753;&#22788;&#29702;&#65292;&#21542;&#21017;&#21487;&#20197;&#24573;&#30053;&#35813;&#27493;&#39588;</font></b>
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.IncreasePointer(context.DataPointerVar, tempInteger);&#160;&#160;&#160;&#160; &#160;&#160;&#160;// data += tempInteger <b><font color="#009999">&#31227;&#21160;&#25351;&#38024;&#65292;&#30830;&#20445;&#19979;&#20010;&#21442;&#25968;&#33021;&#33719;&#21462;&#27491;&#30830;&#30340;&#25351;&#38024;&#20301;&#32622;DataPointerVar</font></b>
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.DecreaseInteger(context.RemainingBytesVar, tempInteger);&#160; &#160;&#160;&#160;// remainingBytes -= tempInteger&#160; <b><font color="#009999">&#20462;&#27491;&#24453;&#22788;&#29702;&#23383;&#33410;&#25968;</font></b>
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;il.MarkLabel(endOfSubmethodLabel);&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;// label endOfSubmethodLabel
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;}
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1419838923018" FOLDED="true" ID="ID_1076947438" MODIFIED="1420004592285" TEXT="&#x51e0;&#x4e2a;&#x70b9;">
<node CREATED="1419838928138" ID="ID_1385400465" MODIFIED="1419839232417" TEXT="string&#x662f;unicode&#x5b57;&#x7b26;&#xff0c;&#x5f15;&#x7528;&#x7c7b;&#x578b;&#xff0c;&#x800c;char[]&#x662f;&#x5b57;&#x8282;&#x6570;&#x7ec4;&#xff0c;unicode&#x5b57;&#x7b26;&#x5360;&#x7528;&#x4e24;&#x4e2a;&#x5b57;&#x8282;,string.length&#x8fd4;&#x56de;&#x7684;&#x53ea;&#x662f;&#x5b57;&#x7b26;&#x6570;">
<node CREATED="1419839193866" ID="ID_1637188472" MODIFIED="1419839265539" TEXT="Encode&#x65f6;&#xff0c;string -&gt; char[]&#xff0c;&#x957f;&#x5ea6;&#x8981;&#x4e58;&#x4ee5;2"/>
<node CREATED="1419839235978" ID="ID_112402733" MODIFIED="1419839277018" TEXT="Decode&#x65f6;&#xff0c;char[]-&gt;string,&#x957f;&#x5ea6;&#x8981;&#x9664;2&#x6765;new string"/>
</node>
<node CREATED="1419838974202" ID="ID_97256375" MODIFIED="1419839037730" TEXT="&#x6307;&#x9488;&#x64cd;&#x4f5c;mananged &#x53d8;&#x91cf;&#xff0c;&#x5fc5;&#x987b;&#x5c06;&#x8be5;&#x53d8;&#x91cf;&#x58f0;&#x660e;&#x4e3a;pin&#xff0c;&#x624d;&#x4e0d;&#x4f1a;&#x5bfc;&#x81f4;&#x5783;&#x573e;&#x56de;&#x6536;&#x5668;&#x56de;&#x6536;"/>
</node>
</node>
<node CREATED="1420005768201" ID="ID_1948523890" MODIFIED="1420005790493" TEXT="StructualCodeBase">
<node CREATED="1419845066362" ID="ID_305581359" MODIFIED="1420006423007" TEXT="DataContractCodec">
<node CREATED="1420005822678" ID="ID_1398147890" MODIFIED="1420005834297" TEXT="StructualCodeBase&lt;PropertyInfo&gt;"/>
</node>
<node BACKGROUND_COLOR="#ffffcc" CREATED="1419845057994" ID="ID_1997191857" MODIFIED="1420007846692" TEXT="FieldsCodec">
<font BOLD="true" NAME="SansSerif" SIZE="12"/>
<node CREATED="1420005804200" ID="ID_1410665205" MODIFIED="1420005817153" TEXT="StructualCodeBase&lt;FieldInfo&gt;"/>
<node CREATED="1420006381446" ID="ID_314857016" MODIFIED="1420006416801" TEXT="&#x5efa;&#x8bae;&#x91c7;&#x7528;struct&#xff0c;&#x652f;&#x6301;&#x5d4c;&#x5957;&#xff0c;&#x4e5f;&#x652f;&#x6301;&#x5404;&#x7c7b;int[],float[]...&#x7b49;"/>
<node CREATED="1420007378406" ID="ID_302894289" MODIFIED="1420007386172" TEXT="&#x91cd;&#x70b9;&#x6d4b;&#x8bd5;&#x7684;&#x7c7b;"/>
</node>
</node>
</node>
<node CREATED="1419839321866" ID="ID_1826234020" MODIFIED="1419839603577" TEXT="Encode/Decode&#x6d41;&#x7a0b;">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#25968;&#25454;<b><font color="#009900">&#21457;&#36865;&#26041;</font></b>&#20026;Encode&#65292;&#21363;&#35201;&#26681;&#25454;&#19981;&#21516;&#21442;&#25968;&#31867;&#22411;&#65292;&#35843;&#29992;&#19981;&#21516;&#30340;EmittingCodec&#26469;&#23558;&#21442;&#25968;&#36716;&#25442;&#20026;==&gt;&#23383;&#33410;&#25968;&#32452;&#12290;
    </p>
    <p>
      &#25968;&#25454;<b><font color="#6600ff">&#25509;&#25910;&#26041;</font></b>&#20026;Decode&#65292;&#21516;&#26679;&#26681;&#25454;&#19981;&#21516;&#21442;&#25968;&#31867;&#22411;&#65292;&#35843;&#29992;&#19981;&#21516;&#30340;EmittingCodec&#26469;&#23558;&#23383;&#33410;&#25968;&#32452;&#36716;&#25442;&#20026;==&gt;&#20855;&#20307;&#30340;&#21442;&#25968;&#20540;&#12290;
    </p>
    <p>
      
    </p>
    <p>
      &#36825;&#37324;&#26041;&#27861;&#30340;&#21442;&#25968;&#38598;&#21512;Parameters&#30340;&#39034;&#24207;&#26159;&#22266;&#23450;&#30340;&#65292;&#25152;&#20197;&#65292;Encode/Decode&#20063;&#23558;&#25353;&#29031;&#21516;&#26679;&#30340;&#39034;&#24207;&#36827;&#34892;&#22788;&#29702;&#65292;&#27599;&#20010;&#21442;&#25968;&#23545;&#24212;&#30340;&#23383;&#33410;&#25968;&#32452;&#20449;&#24687;&#20026;&#65306;<b><font color="#009900">&#25968;&#25454;&#38271;&#24230;+&#20855;&#20307;&#25968;&#25454;</font></b>&#12290;
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
<node CREATED="1419817870761" ID="ID_128924616" MODIFIED="1419817872133" TEXT="SharpRpc.Reflection"/>
<node CREATED="1419817890345" ID="ID_11384599" MODIFIED="1419817891557" TEXT="SharpRpc.ClientSide">
<node CREATED="1419817893384" ID="ID_544482109" MODIFIED="1419817897797" TEXT="SharpRpc.ClientSide.Proxy"/>
</node>
<node CREATED="1419817921658" ID="ID_1695211005" MODIFIED="1419817922784" TEXT="SharpRpc.ServerSide">
<node CREATED="1419817924441" ID="ID_502693193" MODIFIED="1419817934957" TEXT="SharpRpc.ServerSide.Handler"/>
</node>
</node>
<node CREATED="1420007875671" FOLDED="true" ID="ID_1140460373" MODIFIED="1420512845945" POSITION="right" TEXT="&#x5927;&#x81f4;&#x6d41;&#x7a0b;&#x63cf;&#x8ff0;">
<node CREATED="1420007883558" ID="ID_1301552991" MODIFIED="1420007895257" TEXT="define interface">
<node CREATED="1420007897558" ID="ID_1633729482" MODIFIED="1420007924992" TEXT="create proxyclass implement interface">
<node CREATED="1420007927382" ID="ID_1239848333" MODIFIED="1420007999872" TEXT="1&#x3001;convert every arg into one byte[] (proxymethodemttingcontext.dataPointerVar)"/>
<node CREATED="1420008001478" ID="ID_243343800" MODIFIED="1420008037223" TEXT="2&#x3001;invoke  sendProcessor send this byte[] to remoting server and wait result"/>
</node>
<node CREATED="1420008478950" ID="ID_184663451" MODIFIED="1420008494761" TEXT="receiver ">
<node CREATED="1420008501590" ID="ID_1882250612" MODIFIED="1420008534470" TEXT="get entire data and init requestprocessor">
<node CREATED="1420008688870" ID="ID_626065013" MODIFIED="1420008725282" TEXT="create handler then invoke real server method then convert into byte[] then repsonse to client"/>
</node>
</node>
</node>
<node BACKGROUND_COLOR="#99ff99" CREATED="1420008764230" ID="ID_1072036099" MODIFIED="1420008802276" TEXT="&#x8bf4;&#x767d;&#x4e86;&#xff0c;&#x5b9e;&#x73b0;&#x4e00;&#x4e2a;&#x5ba2;&#x6237;&#x7aef;&#xff0c;&#x670d;&#x52a1;&#x7aef;&#x7684;sender &#x548c; receiver&#x5373;&#x53ef;"/>
</node>
</node>
</map>