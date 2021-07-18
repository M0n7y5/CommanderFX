using System;
namespace CommanderFX.Attributes
{
	[AttributeUsage(.Parameter | .Class, .AlwaysIncludeTarget | .DisallowAllowMultiple | .ReflectAttribute)]
	struct RemainingTextAttribute : Attribute
	{
	}
}
