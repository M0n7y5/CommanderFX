using CommanderFX.Attributes;
using System;
namespace CommanderFX.Test.Commands
{
	class CommandsCustomArgumentTypes : CommandBase
	{
		[Command, Description("Custom function with custom argument type.")]
		public void CustomFunc( int i1, int i2, bool b1,
			[RemainingText, Description("My argument")]CustomType arg)
		{
			Console.WriteLine(arg);
		}
	}
}
