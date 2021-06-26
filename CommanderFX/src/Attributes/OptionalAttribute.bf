using System;
namespace CommanderFX.Attributes
{
	[AttributeUsage(.Parameter, .AlwaysIncludeTarget | .DisallowAllowMultiple | .ReflectAttribute)]
	struct OptionalAttribute : Attribute,
		this(Object value = null)
	{
	}
}
