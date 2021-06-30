using System;
using static System.Reflection.MethodInfo;
namespace CommanderFX.Enums
{
	enum InvokeError
	{
		case Unknown;// u should not get this, this means i forgot to handle something
		case EmptyInput;
		case InvalidNumberOfArguments(int expected, int got);
		case CommandNotFound(StringView cmdName);
		case NoConverterForArgumentType(StringView typeName);
		case ParsingError(int argIdx, StringView argRaw);
		case CallingError(CallError error); // this will be resolved internally later
	}
}
