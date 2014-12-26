<map version="1.0.1">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1419576960326" ID="ID_1675323572" MODIFIED="1419577193382" TEXT="SharpRpc">
<node CREATED="1419582998528" ID="ID_671033355" MODIFIED="1419583424002" POSITION="right" TEXT="TestHost">
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
      &#160;&#160;<font color="#006666"><b>&#160;kernel.StartHost();</b></font>
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
      &#160;&#160;&#160;&#160;<font color="#330066"><b>kernel.StopHost();</b></font>
    </p>
    <p>
      }
    </p>
  </body>
</html>
</richcontent>
<node CREATED="1419578956464" ID="ID_1044812488" MODIFIED="1419584452615" TEXT="RpcClientServer">
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
</html>
</richcontent>
<node CREATED="1419581442960" ID="ID_573154011" MODIFIED="1419581467858" TEXT="&#x6784;&#x9020;&#x51fd;&#x6570;&#x521d;&#x59cb;&#x5316;">
<node CREATED="1419579057664" ID="ID_1351832423" MODIFIED="1419585951595" TEXT="RpcClientServerComponentContainer  componentContainer = new ...">
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
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;public RpcClientServerComponentContainer(IRpcClientServer <font color="#ff0000"><b>clientServer</b></font>, RpcComponentOverrides <font color="#ff0000"><b>overrides</b></font>)
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
</html>
</richcontent>
</node>
<node CREATED="1419585051089" ID="ID_880207697" MODIFIED="1419586249739" TEXT="componentContainer.GetServiceImplementationContainer()">
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
</html>
</richcontent>
<node CREATED="1419585155969" ID="ID_1666347409" MODIFIED="1419587760002" TEXT="serviceImplementationContainer">
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
</html>
</richcontent>
<node CREATED="1419585173137" ID="ID_768800" MODIFIED="1419585649860" TEXT="IServiceImplementationContainer">
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
<node CREATED="1419585348833" ID="ID_545583851" MODIFIED="1419585650988" TEXT="ServiceImplementationInfo">
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
      &#160;&#160;public ServiceImplementationInfo(<font color="#006666">ServiceDescription</font>&#160; description, <font color="#0000ff"><b>object</b></font>&#160;implementation)&#160;&#160;&#160;&#160;&#160;&#160;&#160;
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
</node>
<node CREATED="1419585797952" ID="ID_705362828" MODIFIED="1419585821887" TEXT=""/>
<node CREATED="1419581051936" ID="ID_1802183036" MODIFIED="1419585845022" TEXT="componentContainer.GetRequestReceiverContainer().GetReceiver()&#x65b9;&#x6cd5;">
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
<node CREATED="1419579313087" ID="ID_29479737" MODIFIED="1419579724347" TEXT="RequestReceiverContainer">
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
<node CREATED="1419585092928" ID="ID_1421156847" MODIFIED="1419585102238" TEXT="GetReceiver()"/>
</node>
</node>
</node>
<node BACKGROUND_COLOR="#ffff00" COLOR="#000000" CREATED="1419580453488" ID="ID_780589851" MODIFIED="1419585715895" TEXT="StartHost&#xff1a;&#x6240;&#x6709;RpcClientServer&#x7684;&#x5176;&#x4ed6;&#x63a5;&#x53e3;&#x65b9;&#x6cd5;&#x90fd;&#x662f;&#x56f4;&#x7ed5;&#x7740;&#x5b83;&#x518d;&#x8c03;&#x7528;">
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
</html>
</richcontent>
<node CREATED="1419584959072" ID="ID_498778296" MODIFIED="1419584976246" TEXT=" serviceImplementationContainer.GetImplementation"/>
<node CREATED="1419584988160" ID="ID_1152707399" MODIFIED="1419584989673" TEXT="proxyContainer.GetProxy&lt;T&gt;"/>
</node>
<node CREATED="1419584693984" ID="ID_1955765740" MODIFIED="1419584702450" TEXT="StopHost"/>
<node CREATED="1419584704336" ID="ID_617734343" MODIFIED="1419584721073" TEXT="GetInitializedScopesFor"/>
</node>
</node>
</node>
</map>
