using System;
namespace CommanderFX.Entities
{
	class CommandArgument
	{
		public StringView Name { get; private set; }

		public Type Type { get; private set; }

		public bool IsArray { get => this.Type.IsArray; }

		public bool IsOptional { get; private set; }

		public bool IsRemainingText { get; private set; }

		public Object DefaultValue { get; private set; }

		public StringView Description { get; private set; }




	}
}
