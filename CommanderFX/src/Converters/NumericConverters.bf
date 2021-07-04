using System;
namespace CommanderFX.Converters
{
	class BoolConv : BaseConverter<bool>
	{
		public override Result<bool> Convert(StringView value)
		{
			return bool.Parse(value);
		}
	}

	class IntConv<T> : BaseConverter<T> where T : IInteger
	{
		public override Result<T> Convert(StringView value)
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
	}
}
