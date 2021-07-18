using System;
namespace CommanderFX.DependencyInjection
{
	interface IServiceProviderAdapter : IServices
	{
		Result<Object> ResolveSingleton(Object requestedDependency);

		Result<Object> ResolveTransient(Object requestedDependency);
	}
}
