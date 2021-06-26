using System.Collections;
using System;
using System.Reflection;
using CommanderFX.Entities;
using System.Diagnostics;
using CommanderFX.Attributes;
using System.Collections;
using CommanderFX.Converters;
using static System.Reflection.MethodInfo;
namespace CommanderFX
{
	class Commander
	{
		private Dictionary<StringView, Command> ResolvedCommands = new .();
		private Dictionary<int, Variant> Modules = new .();
		private Dictionary<Type, IArgumentConverter> ArgumentConverters = new .()
			{
				(typeof(bool), new BoolConv()),
				(typeof(int8), new IntConv<int8>()),
				(typeof(int16), new IntConv<int16>()),
				(typeof(int32), new IntConv<int32>()),
				(typeof(int64), new IntConv<int64>()),
				(typeof(int), new IntConv<int>()),
				(typeof(uint8), new IntConv<uint8>()),
				(typeof(uint16), new IntConv<uint16>()),
				(typeof(uint32), new IntConv<uint32>()),
				(typeof(uint64), new IntConv<uint64>()),
				(typeof(uint), new IntConv<uint>()),
				(typeof(StringView), new StringViewConverter())
			};

		public ~this()
		{
			DeleteDictionaryAndValues!(ArgumentConverters);
			DeleteDictionaryAndValues!(ResolvedCommands);
			for (var mod in Modules)
				mod.value.Dispose();
			delete Modules;
		}

		public Commander RegisterModule<T>() where T : new, class
		{
			return RegisterModule<T>(null);
		}

		public Commander RegisterModule<T>(T module) where T : new, class
		{
			let type = typeof(T);
			let typeName = type.GetFullName(.. scope String());
			let hash = typeName.GetHashCode();

			Variant mod;

			if (module == null)
			{
				Debug.Assert(!Modules.ContainsKey(hash), scope $"Module: {typeName} is already registered!");

				// add new instance of a module to dic
				mod = Variant.Create(new T(), true);
				Modules.Add(hash, mod);
			}
			else
			{
				Debug.Assert(!Modules.ContainsKey(hash), scope $"Module: {typeName} is already registered!");

				mod = .Create(module);
				// add already allocated module to dic
				Modules.Add(hash, mod);
			}

			for (let method in type.GetMethods())
			{
				if (let attr = method.GetCustomAttribute<CommandAttribute>())
				{
					let cmd = new Command();
					if (attr.Name == null)
						cmd.[Friend]Name = method.Name;
					else
						cmd.[Friend]Name = attr.Name;

					if (let attrDesc = method.GetCustomAttribute<DescriptionAttribute>())
					{
						cmd.[Friend]Description = attrDesc.description;
					}

					cmd.[Friend]Module = mod;
					cmd.[Friend]MethodInfo = method;

					if (method.ParamCount == 0)
					{
						ResolvedCommands.Add(cmd.Name, cmd);
						continue;
					}
					else
					{
						// NOTE: index start from 0
						for (int idx = 0; idx < method.ParamCount; idx++)
						{
							let cmdArg = new CommandArgument();

							cmdArg.[Friend]Name = method.GetParamName(idx);
							cmdArg.[Friend]Type = method.GetParamType(idx);

							if (let argOpt = cmdArg.Type.GetCustomAttribute<OptionalAttribute>())
							{
								cmdArg.[Friend]isOptional = true;
							}

							if (let argDesc = cmdArg.Type.GetCustomAttribute<DescriptionAttribute>())
							{
								cmdArg.[Friend]Description = argDesc.description;
							}

							cmd.Arguments.Add(cmdArg);
						}

						ResolvedCommands.Add(cmd.Name, cmd);
					}
				}
				else
					continue;
			}

			return this;
		}

		public Commander AddDependency<T>(T dep)
		{
			return this;
		}

		public Result<void, CallError> ProccessCommandInput(StringView input)
		{
			var splitEnum = input.Split(' ');
			if (let cmdName = splitEnum.GetNext())
			{
				Command cmd;
				if (ResolvedCommands.TryGetValue(cmdName, out cmd))
				{
					let argsCount = cmd.Arguments.Count;

					List<StringView> argsStr = scope List<StringView>();

					for (let param in splitEnum)
					{
						argsStr.Add(scope $"{param}");
					}

					if (argsCount != argsStr.Count)
						return .Err;// Invalid number of arguments from user

					if (argsCount == 0)
						return cmd(null);

					Variant[] parsedArgs = scope Variant[cmd.Arguments.Count];
					defer // deferred execution
					{
						for(var pArg in parsedArgs)
							pArg.Dispose(); // dispose it right away
						// cuz if object is bigger than int then its allocated
						// and owned by us
					}

					var idx = 0;
					for (let arg in cmd.Arguments)
					{
						if (let conv = ArgumentConverters.GetValue(arg.Type))
						{
							let str = argsStr[idx];

							if (let converted = conv.ConvertVar(str))
							{
								parsedArgs[idx++] = converted;
							}
						}
						else
							Runtime.FatalError("Argument type is not supported. Custom argument converter needed!");
					}

					return cmd.Invoke(parsedArgs);
				}
				else
					return .Err;// Cmd doesnt exist
			}
			else
				return .Err;// empty cmdname
		}

	}
}
