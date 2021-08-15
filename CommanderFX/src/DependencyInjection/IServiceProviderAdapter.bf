using System;
namespace CommanderFX.DependencyInjection
{
	interface IServiceProviderAdapter : IServices
	{
		Result<Object> ResolveDependency(Object requestedDependency);
	}
}
