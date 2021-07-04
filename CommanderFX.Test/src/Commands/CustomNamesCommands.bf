using CommanderFX.Attributes;
using System;
namespace CommanderFX.Test.Commands
{
	class CustomNamesCommands : CommandBase
	{
		[Command("sv_restart"), Description("Restart server.")]
		public void Restart()
		{
			Console.WriteLine("Restating ...");
		}

		[Command("sv_print"), Description("Print a message.")]
		public void Print(StringView msg)
		{
			Console.WriteLine($"Printing: {msg}");
		}

		[Command("sv_cheats"), Description("Enable cheats on server.")]
		public void Print(bool enable)
		{
			Console.WriteLine($"Cheats are enabled? {enable}");
		}
	}
}
