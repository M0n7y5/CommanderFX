using CommanderFX.Attributes;
using System;
namespace CommanderFX.Test.Commands
{
	class ServerCommands : CommandBase
	{
		[Command, Description("Restart Server.")]
		public void Restart()
		{
			Console.WriteLine("Restating ...");
		}

		[Command, Description("Will update server.")]
		public void Update()
		{
			Console.WriteLine("Updating ...");
		}

		[Command, Description("Print global server message.")]
		public void Say(
			[RemainingText, Description("Message that will be displayed"), Optional]
			StringView message = "Sheeesh")
		{
			Console.WriteLine(scope $"Messsage from server: {message}");
		}

		[Command, Description("Sum two numbers together.")]
		public void Sum(int a, int b)
		{
			Console.WriteLine($"Sum: {a} + {b} = {a + b}");
		}

	}
}
