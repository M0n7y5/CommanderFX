using System;
namespace CommanderFX.Converters
{

	// I probably don't want to Commander to own Strings
	// due to possible issues with multi threading (that will be supported later)
	 // ...
	class StringViewConverter : BaseConverter<StringView>
	{
		public override Result<StringView> Convert(StringView value)
		{
			return .Ok(value);
		}

		public override Result<Variant> ConvertVar(StringView value)
		{
			if (let result = Convert(value))
			{
				return .Ok(.Create(result));
			}
			else
				return .Err;
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
