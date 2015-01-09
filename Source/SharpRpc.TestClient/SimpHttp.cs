using System;
using System.Text;
using System.Net;
using System.IO;

namespace SharpRpc.TestClient
{
	public class SimpHttp
	{
		public SimpHttp ()
		{
		}

		public static string Request(string url, string content)
		{		

			HttpWebRequest httpRequest = (HttpWebRequest)WebRequest.Create(url);

			byte[] compressByte = null;
			string error = string.Empty;

			compressByte = Encoding.UTF8.GetBytes(content);

			httpRequest.Method = "POST";
			httpRequest.ContentLength = compressByte.Length;
			Stream reqStream = httpRequest.GetRequestStream();
			reqStream.Write(compressByte, 0, compressByte.Length);
			reqStream.Close();

			HttpWebResponse response = (HttpWebResponse)httpRequest.GetResponse();

			string responseContent = string.Empty;

			using (StreamReader reader = new StreamReader(response.GetResponseStream(), Encoding.UTF8))
			{
				responseContent = reader.ReadToEnd();
			}

			return responseContent;
		}
	}
}

