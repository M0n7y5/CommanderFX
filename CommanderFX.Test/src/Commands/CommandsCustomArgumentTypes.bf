using CommanderFX.Attributes;
using System;
namespace CommanderFX.Test.Commands
{
	class CommandsCustomArgumentTypes : CommandBase
	{
		[Command, Description("Custom function with custom argument type.")]
		public void CustomFunc(CustomType arg)
		{
			Console.WriteLine(arg);
		}
	}
}
