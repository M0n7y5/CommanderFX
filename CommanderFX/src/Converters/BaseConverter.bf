using System;
namespace CommanderFX.Converters
{
	abstract class BaseConverter<T> : IArgumentConverter, IArgumentConverter<T> 
	{
		public abstract Result<Variant> ConvertVar(StringView value);

		/*public Result<Variant> ConvertVar(StringView value)
		{
			if (let result = Convert(value))
			{
				return .Ok(.Create(result));
			}
			else
				return .Err;
		}*/

		public abstract Result<T> Convert(StringView value);
	}
}
