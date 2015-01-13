using System;

namespace SharpRpc.ServerSide.SocketServer
{
	public interface ISocketServer
	{
		/// <summary>
		/// Возвращает признак того, доступен ли в данный момент сервер
		/// </summary>
		bool Started { get; }

		/// <summary>
		/// Возвращает логический сервер
		/// </summary>
		ILogicServer LogicServer { get; }

		/// <summary>
		/// Запускает сервер
		/// </summary>
		void Start();

		/// <summary>
		/// Останавливает сервер
		/// </summary>
		void Stop();

		/// <summary>
		/// Перезапускает сервер
		/// </summary>
		void Restart();
	}
}

