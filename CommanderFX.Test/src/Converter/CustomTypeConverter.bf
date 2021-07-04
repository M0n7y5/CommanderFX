using CommanderFX.Converters;
using System;
namespace CommanderFX.Test.Converter
{
	class CustomTypeConverter : BaseConverter<CustomType>
	{
		public override Result<CustomType> Convert(StringView value)
		{
			return default;
		}
	}
}
