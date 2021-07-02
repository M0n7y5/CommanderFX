using System;
using CommanderFX;
using CommanderFX.Attributes;
using System.Collections;
using CommanderFX.Converters;
using CommanderFX.Entities;

namespace CommanderFX.Test
{
	class ServerCommands
	{
		[Command, Description("Restart Server")]
		public void Restart()
		{
			Console.WriteLine("Restating ...");
		}

		[Command, Description("Will update server")]
		public void Update()
		{
			Console.WriteLine("Updating ...");
		}

		[Command, Description("Print global server message")]
		public void Say(
			[RemainingText, Description("Message that will be displayed"), Optional]
			StringView message = "Sheeesh")
		{
			Console.WriteLine(scope $"Messsage from server: {message}");
		}

		[Command]
		public void Sum(int a, int b)
		{
			Console.WriteLine($"Sum: {a} + {b} = {a + b}");
		}

		[Command]
		public void Sum(int32 a, int32 b)
		{
			Console.WriteLine($"Sum: {a} + {b} = {a + b}");
		}
	}

	class Program
	{
		public static int Main(String[] args)
		{
			let cmder = scope Commander();

			cmder.RegisterModule<ServerCommands>();
			//cmder.RegisterModule<ServerCommands>();

			cmder.ProccessCommandInput("Update");
			cmder.ProccessCommandInput("Restart");
			cmder.ProccessCommandInput("Say AMOGUS!");
			cmder.ProccessCommandInput("Sum 46 158");

			if(cmder.ProccessCommandInput("Char c") case .Err(let err))
			{
				Console.WriteLine(err);
			}

			//cmder.ProccessCommandInput("InvalidCmd");

			Console.Read();
			return 0;
		}

		[Test]
		public static void T_CommandRegister()
		{

		}
	}

	[CommandModule]
	class TestClass
	{
		int i;

		[AlwaysInclude]
		public this()
		{
		}
	}
}