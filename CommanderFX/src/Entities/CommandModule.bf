using System;
using CommanderFX.Enums;
namespace CommanderFX.Entities
{
	class CommandModule : ICommandModule
	{
		Object _instance;

		/// Dont forget to delete module if its transient
		/// kinda gay ngl i know
		public T GetInstance<T>() where T : class, new
		{
			switch (LifeSpan)
			{
			case .Singleton:
				return _instance as T;
			case .Transient:
				return new T();
			default:
				return default;
			}
		}

		public this(Type Module, ModuleLifeSpan lifeSpan)
		{
			this.ModuleType = Module;
			this.LifeSpan = lifeSpan;
		}

		public this(Object instance, Type Module, ModuleLifeSpan lifeSpan)
		{
			this.ModuleType = Module;
			this.LifeSpan = lifeSpan;
			this._instance = instance;
		}

		public Type ModuleType { get; private set; }

		public ModuleLifeSpan LifeSpan { get; private set; }


	}
}
