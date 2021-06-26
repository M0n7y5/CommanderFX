using System;
namespace CommanderFX.Converters
{
	class BoolConv : IArgumentConverter<bool>
	{
		public Result<bool> Convert(StringView value)
		{
			return bool.Parse(value);
		}

		public Result<Variant> ConvertVar(StringView value)
		{
			if (let result = Convert(value))
			{
				return .Ok(.Create(result));
			}
			else
				return .Err;
		}
	}

	class IntConv<T> : IArgumentConverter<T> where T : IInteger
	{
		public Result<T> Convert(StringView value)
		{
			let max = Variant.Create(typeof(T).MaxValue).Get<int>();
			let min = Variant.Create(typeof(T).MinValue).Get<int>();

			if (let val = int.Parse(value))
			{
				if (val >= min && val <= max)
				{
					return .Ok(Variant.Create(val).Get<T>());
				}
			}

			return .Err;
		}

		public Result<Variant> ConvertVar(StringView value)
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
