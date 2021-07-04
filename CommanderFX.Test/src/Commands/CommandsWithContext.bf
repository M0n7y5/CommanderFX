using CommanderFX.Attributes;
using System;
namespace CommanderFX.Test.Commands
{
	class CommandsWithContext : CommandBase
	{
		
		[Command, Description("Show available commands.")]
		public void Help()
		{
			Console.WriteLine("Available commands:");

			for(let cmd in ctx.AvailableCommands)
			{
				Console.WriteLine($"\t{cmd.key}: {cmd.value.Description}");
			}
		}
	}
}
