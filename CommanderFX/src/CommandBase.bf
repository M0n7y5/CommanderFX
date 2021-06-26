using System;
namespace CommanderFX
{
	[Reflect(.All)]
	abstract class CommandBase
	{
		[AlwaysInclude]
		public this()
		{

		}
	}
}
