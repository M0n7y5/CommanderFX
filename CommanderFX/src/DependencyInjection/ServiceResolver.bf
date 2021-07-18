using System;
namespace CommanderFX.DependencyInjection
{
	class ServiceResolver : IServices
	{
		private IServiceProviderAdapter _adapter;

		public this(IServiceProviderAdapter adapter)
		{
			this._adapter = adapter;
		}

		public Object GetService<T>()
		{
			return _adapter;
		}
	}
}
