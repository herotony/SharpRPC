using System;
using System.IO;
using System.Text.RegularExpressions;

namespace Parse.Rpc.StepByStep
{
	//强调格式必须为：protocol://host:port
	public struct ServiceEndPoint :IEquatable<ServiceEndPoint>
	{
		public string Protocol;
		public string Host;
		public int Port;

		public ServiceEndPoint(string protocol, string host, int port)
		{
			Protocol = protocol;
			Host = host;
			Port = port;
		}

		public static bool Equals(ServiceEndPoint ep1, ServiceEndPoint ep2)
		{
			return ep1.Protocol == ep2.Protocol && ep1.Host == ep2.Host && ep1.Port == ep2.Port;
		}

		public static bool operator ==(ServiceEndPoint ep1, ServiceEndPoint ep2)
		{
			return string.Equals(ep1, ep2) && ep1.Port == ep2.Port;
		}

		public static bool operator !=(ServiceEndPoint ep1, ServiceEndPoint ep2)
		{
			return !(ep1 == ep2);
		}

		public bool Equals(ServiceEndPoint other)
		{
			return Equals(this, other);
		}

		public override bool Equals(object obj)
		{
			return obj is ServiceEndPoint && Equals(this, (ServiceEndPoint)obj);
		}

		public override int GetHashCode()
		{
			return (Host ?? "").GetHashCode() + Port;
		}

		public override string ToString()
		{
			return Format();
		}

		public string Format()
		{
			return string.Format("{0}://{1}:{2}", Protocol, Host, Port);
		}

		private static readonly Regex EndPointRegex = new Regex(@"^(\w+)://([^:]+):(\d+)$");

		public static bool TryParse(string endPointString, out ServiceEndPoint endPoint)
		{
			if (endPointString == null)
			{
				endPoint = default(ServiceEndPoint);
				return false;
			}
			var match = EndPointRegex.Match(endPointString);
			if (!match.Success)
			{
				endPoint = default(ServiceEndPoint);
				return false;
			}

			var protocol = match.Groups[1].Value;
			var value = match.Groups[2].Value;

			int port;
			if (!int.TryParse(match.Groups[3].Value, out port))
			{
				endPoint = default(ServiceEndPoint);
				return false;
			}

			endPoint = new ServiceEndPoint(protocol, value, port);
			return true;
		}

		public static ServiceEndPoint Parse(string endPointString)
		{
			ServiceEndPoint endPoint;
			if (!TryParse(endPointString, out endPoint))
				throw new InvalidDataException(string.Format("'{0}' is not a valid service end point", endPointString));
			return endPoint;
		}

	}
}

