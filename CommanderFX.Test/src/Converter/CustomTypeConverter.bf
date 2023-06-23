using CommanderFX.Converters;
using System;
namespace CommanderFX.Test.Converter
{
	class CustomTypeConverter : BaseConverter<CustomType>
	{
		public override Result<CustomType> Convert(StringView value)
		{
			let result = new CustomType();
			var idx = 0;
			for (let arg in value.Split(' '))
			{
				switch (idx++)
				{
				case 0:
					if (let res = int.Parse(arg))
						result.field1 = res;
					else
						return .Err;
					continue;
				case 1:
					if (let res = int.Parse(arg))
						result.field2 = res;
					else
						return .Err;
					continue;
				case 2:
					if (let res = bool.Parse(arg))
						result.field3 = res;
					else
						return .Err;
					continue;
				}
			}

			if (idx != 3)
				return .Err; //invalid argument count

			return .Ok(result);
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
}
