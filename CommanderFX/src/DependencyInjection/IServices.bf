using System;
namespace CommanderFX.DependencyInjection
{
	interface IServices
	{
		public Object GetService<T>();
	}
}
