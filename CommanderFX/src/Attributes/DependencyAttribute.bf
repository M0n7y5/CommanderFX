using System;
using CommanderFX.Enums;
namespace CommanderFX.Attributes
{
	[AttributeUsage(.Field, .ReflectAttribute | .AlwaysIncludeTarget, ReflectUser = .All)]
	struct DependencyAttribute : Attribute
	{
	}
}
