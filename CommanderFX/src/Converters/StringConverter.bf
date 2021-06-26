using System;
namespace CommanderFX.Converters
{
	
	// I probably don't want to Commander to own Strings
	// due to possible issues with multi threading (that will be supported later)
 	// ...
	class StringViewConverter : IArgumentConverter<StringView>
	{
		public Result<Variant> ConvertVar(StringView value)
		{
			return .Ok(.Create(value));
		}
		public Result<StringView> Convert(StringView value)
		{
			return .Ok(value);
		}
	}

	/*class StringConverter : IArgumentConverter<String>
	{
		public Result<Variant> ConvertVar(StringView value)
		{
			return .Ok(.Create(value));
		}
		public Result<String> Convert(StringView value)
		{
			return .Ok(value);
		}
	}*/
}
