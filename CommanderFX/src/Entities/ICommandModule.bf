using System;
using CommanderFX.Enums;
namespace CommanderFX.Entities
{
	interface ICommandModule
	{
		Type ModuleType { get; }

		ModuleLifeSpan LifeSpan { get; }// probably not needed

		T GetInstance<T>() where T : class, new;
	}
}
