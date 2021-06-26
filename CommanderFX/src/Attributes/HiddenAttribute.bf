using System;
namespace CommanderFX.Attributes
{
	[AttributeUsage(.Method, .AlwaysIncludeTarget | .DisallowAllowMultiple | .ReflectAttribute)]
	struct HiddenAttribute : Attribute
	{
	}
}
