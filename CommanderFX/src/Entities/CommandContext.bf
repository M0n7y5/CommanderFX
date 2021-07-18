using System.Collections;
using System;
using CommanderFX.DependencyInjection;
namespace CommanderFX.Entities
{
	class CommandContext
	{
		/// DO NOT MANIPULATE COMMANDS INSIDE THIS DICTIONARY
		public Dictionary<StringView, Command> AvailableCommands;// { get;  set; }

		public IServices Services;
	}
}
