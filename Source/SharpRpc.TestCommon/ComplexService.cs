using System;
using System.Collections.Generic;
using Sharp.Rpc.CommonObject;
using System.IO;

namespace SharpRpc.TestCommon
{
	public class ComplexService :IComplexService
	{
		public JsonStruct GetXmlOrJsonString(string protocol,string sid,string pid,double lon,double lat,string[] paramStr){

			Console.WriteLine (string.Format ("protocol:{0} sid:{1} pid:{2} lon:{3} lat:{4}",protocol,sid,pid,lon,lat));

			if (paramStr != null && paramStr.Length > 0)
				foreach (string value in paramStr)
					Console.WriteLine ("param :{0}", value);

			JsonStruct[] t = new JsonStruct[2];

			t [0] = new JsonStruct ();

			t [0].Name = "name1";
			t [0].Index = 1;
			t [0].Date = DateTime.Now.AddDays (1);
			t [0].Price = 100;
			t[0].JsonStr =new string[]{"{json:1}","abc"};
			t[0].Reminder="what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1";


			t [1] = new JsonStruct ();

			t [1].Name = "name2";
			t [1].Index = 2;
			t [1].Date = DateTime.Now.AddDays (2);
			t [1].Price = 1000;
			t[1].JsonStr= new string[]{"{json2:2}","bdf"};
			t[1].Reminder="what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试1what is here 测试12";



			return t[0];
		}

		public byte[] GetStudentList(byte[] input){

			List<Student> list = new List<Student> ();

			Random rand = new Random ();

			for (int i = 0; i < 3; i++) {

				Student st = new Student ();

				st.Name = string.Format ("user_test_name_{0}", i);
				st.Age = rand.Next (11, 18);
				st.Male = rand.Next (10) % 2 == 0;
				st.Address = new List<string> ();
				st.Score = rand.Next (60, 100);

				string addr0 = string.Format ("北京大兴区京辅路{0}号", rand.Next (100));
				string addr1 = string.Format ("北京通州区向阳路{0}号", rand.Next (200));

				st.Address.Add (addr0);
				st.Address.Add (addr1);


				list.Add (st);
			}

			Student st2 = list [0];

			MemoryStream stream = new MemoryStream();

			//Google.ProtoBuf.Serializer<Student> (stream, st2);

			Google.ProtoBuf.Serializer.Serialize<List<Student>> (stream, list);

			Console.WriteLine (string.Format ("list.count:{0}", list.Count));
			Console.WriteLine (string.Format ("stream.Length:{0}", stream.Length));

			byte[] buff = new byte[stream.Length];

			stream.Seek (0,SeekOrigin.Begin);

			stream.Read (buff, 0, buff.Length);


			MemoryStream sr2 = new MemoryStream ();

			sr2.Write (buff, 0, buff.Length);

			sr2.Seek (0, SeekOrigin.Begin);

			List<Student> list2 = Google.ProtoBuf.Serializer.Deserialize<List<Student>> (sr2);

			if (list2 == null)
				Console.WriteLine ("fuck");
			else {
				for (int i = 0; i < list2.Count; i++)
					Console.WriteLine (list2 [i].ToString ());
			}

			Console.WriteLine ("over");

			Console.WriteLine (string.Format ("buff.lenght:{0} on time:{1}", buff.Length,DateTime.Now));

			return buff;
		}
	}
}

