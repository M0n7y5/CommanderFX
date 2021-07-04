using System;
using CommanderFX.Test.Commands;
namespace CommanderFX.Test
{
	class CommadsRegistration
	{
		class TestClass : CommandBase
		{

		}

		[Test]
		public static void T_ClassRegister()
		{
			let cmder = scope Commander();
			cmder.RegisterModule<TestClass>();

			Test.Assert(cmder.[Friend]Modules.Count == 1);
		}

		[Test(ShouldFail=true)]
		public static void T_DuplicateClassHandlerFail()
		{
			let cmder = scope Commander();
			cmder.RegisterModule<TestClass>();
			cmder.RegisterModule<TestClass>();
		}

		[Test(ShouldFail=true)]
		public static void T_DuplicateCommandsHandlerFail()
		{
			let cmder = scope Commander();
			cmder.RegisterModule<CommandsDuplicates>();
		}

		[Test]
		public static void T_CommandsRegister()
		{
			let cmder = scope Commander();
			cmder.RegisterModule<ServerCommands>();

			cmder.ProccessCommandInput("Restart");
		}

	}
}
