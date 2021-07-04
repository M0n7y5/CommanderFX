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

		[Test(ShouldFail = true)]
		public static void T_InvalidCommandFail()
		{
			let cmder = scope Commander();
			cmder.RegisterModule<ServerCommands>();
			if (cmder.ProccessCommandInput("Help") case .Err(let err))
			{
				switch (err)
				{
				case .CommandNotFound:
					Test.Assert(false);
				default:
					return;
				}
			}
		}

		[Test(ShouldFail = true)]
		public static void T_InvalidCommandArgumentsParsingFail()
		{
			let cmder = scope Commander();
			cmder.RegisterModule<ServerCommands>();
			if (cmder.ProccessCommandInput("Sum Sheesh Yeet") case .Err(let err))
			{
				switch (err)
				{
				case .ParsingError:
					Test.Assert(false);
				default:
					return;
				}
			}
		}

		[Test(ShouldFail = true)]
		public static void T_InvalidCommandArgumentsCountFail()
		{
			let cmder = scope Commander();
			cmder.RegisterModule<ServerCommands>();
			if (cmder.ProccessCommandInput("Sum 14") case .Err(let err))
			{
				switch (err)
				{
				case .InvalidNumberOfArguments(let expected, let got):
					if (expected == 2 && got == 1)
						Test.Assert(false);
				default:
					return;
				}
			}
		}

		[Test(ShouldFail = true)]
		public static void T_InvalidUnsupportedArgumentFail()
		{
			let cmder = scope Commander();
			cmder.RegisterModule<CommandsCustomArgumentTypes>();
			if (cmder.ProccessCommandInput("CustomFunc lmao") case .Err(let err))
			{
				switch (err)
				{
				case .NoConverterForArgumentType(let type):
					let tmp = typeof(CustomType);
					if (type == tmp)
						Test.Assert(false);
				default:
					return;
				}
			}
		}
	}
}
