using System.Collections;
using System;
using System.Reflection;
using CommanderFX.Entities;
using System.Diagnostics;
using CommanderFX.Attributes;
using System.Collections;
using CommanderFX.Converters;
using CommanderFX.Enums;
using CommanderFX.DependencyInjection;
using static System.Reflection.MethodInfo;
namespace CommanderFX
{

	//TODO: Implement method overload support
	class Commander
	{
		IServiceProviderAdapter ServiceAdapter;
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

		public Commander RegisterConverter<TType, T>()
			where T : new, class, IArgumentConverter
		{
			if (ArgumentConverters.ContainsKey(typeof(T)))
			{
				Runtime.FatalError("Converter is already registered for this type!");
			}

			ArgumentConverters.Add(typeof(TType), new T());
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

							if (let _ = method.GetParamCustomAttribute<OptionalAttribute>(idx))
							{
								cmdArg.[Friend]IsOptional = true;
							}

							if (let argDesc = method.GetParamCustomAttribute<DescriptionAttribute>(idx))
							{
								cmdArg.[Friend]Description = argDesc.description;
							}

							if (let test = method.GetParamCustomAttribute<RemainingTextAttribute>(idx))
							{
								cmdArg.[Friend]IsRemainingText = true;
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

		public Commander RegisterDependencyResolver(IServiceProviderAdapter adapter)
		{
			if(ServiceAdapter != null)
				Runtime.FatalError("");
			this.ServiceAdapter = adapter;
			return this;
		}

		public Result<void, InvokeError> ProccessCommandInput(StringView input)
		{
			//TODO: Handle calling error internally
			int inputStrCursor = 0;
			var splitEnum = input.Split(' ');
			if (let cmdName = splitEnum.GetNext())
			{
				Command cmd;
				if (ResolvedCommands.TryGetValue(cmdName, out cmd))
				{
					inputStrCursor += cmdName.Length + 1/*whitespace*/;

					let argsCount = cmd.Arguments.Count;

					if (argsCount == 0)// no args?, just invoke then
					{
						cmd.Module.Get<CommandBase>().[Friend]ctx = scope CommandContext()
							{
								AvailableCommands = ResolvedCommands
							};

						if (cmd(null) case .Err(let err))
							return .Err(.CallingError(err));
						else
							return .Ok;
					}

					List<StringView> argsStr = scope List<StringView>();

					var tmpEnumm = cmd.Arguments.GetEnumerator();

					for (let param in splitEnum)
					{
						if (let cmdd = tmpEnumm.GetNext())
						{
							if (cmdd.IsRemainingText)
							{
								var remainText = StringView(param.Ptr);
								argsStr.Add(remainText);

								break;
							}

							argsStr.Add(param);
						}
					}

					Variant[] parsedArgs = scope Variant[cmd.Arguments.Count];
					defer// deferred execution
					{
						for (var pArg in parsedArgs)
							pArg.Dispose();// dispose parsed objects right away
						// cuz if object is bigger than int then its allocated
						// and owned by us (and thats gay ngl)
					}

					int idx = 0;
					StringView str = .();
					for (var arg in cmd.Arguments)
					{
						str = argsStr[idx];

						if (let conv = ArgumentConverters.GetValue(arg.Type))
						{
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

					// Invalid number of arguments from user
					if (argsCount != argsStr.Count)
						return .Err(.InvalidNumberOfArguments(argsCount, argsStr.Count));

					cmd.Module.Get<CommandBase>().[Friend]ctx = scope CommandContext()
						{
							AvailableCommands = ResolvedCommands
						};

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
