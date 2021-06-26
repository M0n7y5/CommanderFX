using System;
using System.Reflection;
using System.Collections;
using static System.Reflection.MethodInfo;
namespace CommanderFX.Entities
{
	class Command : IHashable
	{
		public StringView Name { get; private set; }

		public StringView Description { get; private set; }

		public Variant Module { get; private set; }

		public List<CommandArgument> Arguments = new .() ~ DeleteContainerAndItems!(_);

		private MethodInfo MethodInfo;

		public Result<void, CallError> Invoke(Variant[] args)
		{
			if (Arguments.Count == 0)
			{
				if (this.MethodInfo(this.Module) case .Err(let err))
					return .Err(err);
			}
			else
			{
				if (this.MethodInfo(this.Module, params args) case .Err(let err))
					return .Err(err);
			}

			return .Ok;
		}

		public int GetHashCode()
		{
			return Name.GetHashCode();
		}


	}
}
