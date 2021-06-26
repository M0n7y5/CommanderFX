using System;
namespace CommanderFX.Converters
{
	interface IArgumentConverter
	{
		public Result<Variant> ConvertVar(StringView value);
	}

	interface IArgumentConverter<T> : IArgumentConverter
	{
		public Result<T> Convert(StringView value);
	}
}
