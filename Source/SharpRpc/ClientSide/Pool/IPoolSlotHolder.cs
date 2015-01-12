using System;

namespace SharpRpc.ClientSide.Pool
{
	public interface IPoolSlotHolder<T>
	{
		PoolSlot<T> PoolSlot { get; set; }
	}
}

