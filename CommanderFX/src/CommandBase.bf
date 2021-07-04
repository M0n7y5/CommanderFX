using System;
using CommanderFX.Entities;
namespace CommanderFX
{
	abstract class CommandBase
	{
		public CommandContext ctx { get; private set;};

		public this()
		{
		}
	}
}
