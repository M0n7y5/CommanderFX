using System;
namespace CommanderFX.Attributes
{
	[AttributeUsage(.Method, .AlwaysIncludeTarget | .DisallowAllowMultiple | .ReflectAttribute )]
	struct CommandAttribute : Attribute
	{
		public String Name;

		public this()
		{
			this.Name = null;
		}

		public this(String name)
		{
			this.Name = name;
		}
	}
}
