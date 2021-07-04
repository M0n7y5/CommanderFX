using System.Collections;
using System;
using System.Reflection;
using CommanderFX.Entities;
using System.Diagnostics;
using CommanderFX.Attributes;
using System.Collections;
using CommanderFX.Converters;
using CommanderFX.Enums;
using static System.Reflection.MethodInfo;
namespace CommanderFX
{

	//TODO: Implement method overload support
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

		public Commander RegisterConverter<T>() where T : new, class, IArgumentConverter
		{


			return this;
		}

		public Commander RegisterModule<T>() where T : new, class, CommandBase
		{
			return RegisterModule<T>(null);
		}

		public Commander RegisterModule<T>(T module) where T : new, class, CommandBase
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

			//TODO: handle command duplication

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
						// TODO: handle duplicates here
						let addTry = ResolvedCommands.TryAdd(cmd.Name, cmd);

						Debug.Assert(addTry, "Duplicate commands not supported yet!");
					}
				}
				else
					continue;
			}

			return this;
		}

		//TODO: Implement dependency injection
		/*public Commander AddSingletonDep<T>(T dep)
		{
			return this;
		}
		
		//TODO: Implement dependency injection
		public Commander AddTransientDep<T>()
		{
			return this;
		}*/

		public Result<void, InvokeError> ProccessCommandInput(StringView input)
		{
			//TODO: Handle calling error internally

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
						argsStr.Add(param);
					}

					if (argsCount != argsStr.Count)
						return .Err(.InvalidNumberOfArguments(argsCount, argsStr.Count));// Invalid number of arguments
					// from user

					cmd.Module.Get<CommandBase>().[Friend]ctx = scope CommandContext()
						{
							AvailableCommands = ResolvedCommands
						};

					if (argsCount == 0)
						if (cmd(null) case .Err(let err))
							return .Err(.CallingError(err));
						else
							return .Ok;

					Variant[] parsedArgs = scope Variant[cmd.Arguments.Count];
					defer// deferred execution
					{
						for (var pArg in parsedArgs)
							pArg.Dispose();// dispose it right away
						// cuz if object is bigger than int then its allocated
						// and owned by us (and thats gay ngl)
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
							else
								return .Err(.ParsingError(idx, str));
						}
						else
						{
							return .Err(.NoConverterForArgumentType(arg.Type));
						}
					}



					if (cmd(parsedArgs) case .Err(let err))
						return .Err(.CallingError(err));
					else
						return .Ok;
				}
				else
					return .Err(.CommandNotFound(cmdName));// Cmd doesn't exist
			}
			else
				return .Err(.EmptyInput);// empty cmdname
		}

	}
}
