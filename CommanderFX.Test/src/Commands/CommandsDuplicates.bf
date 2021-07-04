using CommanderFX.Attributes;
using System;
namespace CommanderFX.Test.Commands
{
	class CommandsDuplicates : CommandBase
	{
		[Command]
		public void Sum(int a, int b)
		{
			Console.WriteLine($"Sum: {a} + {b} = {a + b}");
		}

		[Command]
		public void Sum(int32 a, int b)
		{
			Console.WriteLine($"Sum: {a} + {b} = {a + b}");
		}
	}
}
