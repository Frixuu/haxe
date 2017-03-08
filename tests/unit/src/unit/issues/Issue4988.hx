package unit.issues;

class Issue4988 extends Test {
	static var value:Dynamic;
	static var actuallyRunCode = false;

	function test() {
		if (actuallyRunCode) {
			try {
				var d:{i:Null<Int>} = null;
				value = (d.i > 0);
				(null:Dynamic).nonExistent();
				#if !(lua || as3)
				null.nonExistent();
				#end
				t(false);
			} catch(e:Dynamic) {
				t(true);
			}
		} else {
			t(true);
		}
	}
}
