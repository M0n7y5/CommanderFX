using System;
namespace CommanderFX.Attributes
{
	[AttributeUsage(.Method | .Parameter, .AlwaysIncludeTarget | .DisallowAllowMultiple | .ReflectAttribute)]
	struct DescriptionAttribute : Attribute,
		this(String description)
	{
	}
}
