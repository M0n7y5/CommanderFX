using System;
namespace CommanderFX.Attributes
{
	[AttributeUsage(.Parameter, .AlwaysIncludeTarget | .DisallowAllowMultiple | .ReflectAttribute)]
	struct RemainingTextAttribute : Attribute
	{
	}
}
