using System;
using CommanderFX.Attributes;
namespace CommanderFX.Test
{
		
	
	class CustomType
	{
		public int field1;
		public int field2;
		public bool field3;

		public override void ToString(String strBuffer)
		{
			strBuffer.Append(scope $"field1: {field1}, field2: {field2}, field3: {field3}");
		}
	}
}
