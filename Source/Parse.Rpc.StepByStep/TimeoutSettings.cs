using System;

namespace Parse.Rpc.StepByStep
{
	//请求超时时间设置，重试次数以及每次重试超时设置
	public class TimeoutSettings: IEquatable<TimeoutSettings>
	{
		public int MaxMilliseconds { get; private set; }
		public int NotReadyRetryCount { get; private set; }
		public int NotReadyRetryMilliseconds { get; private set; }

		public TimeoutSettings(int maxMilliseconds, int retryCount, int retryMilliseconds)
		{
			MaxMilliseconds = maxMilliseconds;
			NotReadyRetryCount = retryCount;
			NotReadyRetryMilliseconds = retryMilliseconds;
		}

		public TimeoutSettings(int maxMilliseconds) : this(maxMilliseconds, int.MaxValue, 0) { }
		public TimeoutSettings(int retryCount, int retryMilliseconds) : this(int.MaxValue, retryCount, retryMilliseconds) { }
		public TimeoutSettings() : this(int.MaxValue, int.MaxValue, 0) { }

		public bool Equals(TimeoutSettings other)
		{
			if (other == null)
				return false;
			if (ReferenceEquals(this, other))
				return true;
			return MaxMilliseconds == other.MaxMilliseconds &&
				NotReadyRetryCount == other.NotReadyRetryCount &&
				NotReadyRetryMilliseconds == other.NotReadyRetryMilliseconds;
		}

		public override bool Equals(object obj)
		{
			return Equals(obj as TimeoutSettings);
		}

		public override int GetHashCode()
		{
			return MaxMilliseconds + NotReadyRetryCount + NotReadyRetryMilliseconds;
		}

		public override string ToString()
		{
			return string.Format("{{MaxMilliseconds: {0}; NotReadyRetryCount: {1}; NotReadyRetryMilliseconds: {2}}}",
				MaxMilliseconds, NotReadyRetryCount, NotReadyRetryMilliseconds);
		}

		public static bool operator ==(TimeoutSettings s1, TimeoutSettings s2)
		{
			if (ReferenceEquals(s1, s2))
				return true;
			if (ReferenceEquals(s1, null))
				return false;
			return s1.Equals(s2);
		}

		public static bool operator !=(TimeoutSettings s1, TimeoutSettings s2)
		{
			return !(s1 == s2);
		}

		public static TimeoutSettings NoTimeout { get { return new TimeoutSettings(); }}
	}
}

