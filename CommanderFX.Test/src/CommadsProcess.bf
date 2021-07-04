using System;
using CommanderFX.Test.Commands;
namespace CommanderFX.Test
{
	class CommadsProcess
	{
		[Test]
		public static void T_UsedMethodNames()
		{
			let cmder = scope Commander();
			cmder.RegisterModule<ServerCommands>();
			cmder.ProccessCommandInput("Restart");
			cmder.ProccessCommandInput("Update");
			cmder.ProccessCommandInput("Say AMOGUS!");
			cmder.ProccessCommandInput("Sum 11 31");
		}

		[Test]
		public static void T_CustomMethodNames()
		{
			let cmder = scope Commander();
			cmder.RegisterModule<CustomNamesCommands>();
			cmder.ProccessCommandInput("sv_restart");
			cmder.ProccessCommandInput("sv_print Yeet!");
			cmder.ProccessCommandInput("sv_cheats true");
			cmder.ProccessCommandInput("sv_cheats false");
		}

		[Test]
		public static void T_MethodWithContext()
		{
			let cmder = scope Commander();
			cmder.RegisterModule<ServerCommands>();
			cmder.RegisterModule<CommandsWithContext>();
			cmder.RegisterModule<CustomNamesCommands>();
			cmder.ProccessCommandInput("Help");
		}
	}
}
