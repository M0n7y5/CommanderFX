using System;
namespace CommanderFX.Attributes
{
	[AttributeUsage(.Class, .ReflectAttribute | .AlwaysIncludeTarget, ReflectUser = .All)]
	struct CommandModuleAttribute : Attribute
	{
	}
}
