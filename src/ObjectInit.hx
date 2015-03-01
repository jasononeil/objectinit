import haxe.macro.Expr;
import haxe.macro.Context;
using haxe.macro.ExprTools;

/**
	A helper utility to initialize variables on objects without giant setters/getters.

	An example, using a pretend model `Project`:

	```haxe
	using ObjectInit;
	
	// Writing this:
	var p = new Project().init({ name:"ObjectInit", downloads:1000000, tags:["macro","helper"] });

	// Is the same as writing:
	var p = new Project();
	p.name = "ObjectInit";
	p.downloads = 1000000;
	p.tags = ["macro","helper"];

	// You can even use it in a function call:
	uploadProject( new Project().init({ name:"ObjectInit", downloads:1000000, tags:["macro","helper"] }) );
	```

	It runs as a macro, so it's type safe.  In the example above, `new Project().init({ downloads:"not-a-number" })` would fail to compile, because of the incorrect type.
**/
class ObjectInit {
	macro public static function init( expr:Expr, varsToSet:ExprOf<Dynamic<Dynamic>> ) {
		return doTransformation( expr, varsToSet );
	}

	/** An alias for `init()`, in case you need to use it on an object which already has a method called `init()`. **/
	macro public static function objectInit( expr:Expr, varsToSet:ExprOf<Dynamic<Dynamic>> ) {
		return doTransformation( expr, varsToSet );
	}

	static function doTransformation( expr:Expr, varsToSet:ExprOf<Dynamic<Dynamic>> ) {
		var lines:Array<Expr> = [];
		lines.push( macro var __obj_init_tmp = $expr );
		switch varsToSet.expr {
			case EObjectDecl(fields):
				for ( field in fields ) {
					var varName = field.field;
					var varValue = field.expr;
					lines.push( macro __obj_init_tmp.$varName = $varValue );
				}
			case other: Context.error( 'Expected ${expr.toString()}.init() argument to be an object declaration', expr.pos );
		}
		lines.push( macro __obj_init_tmp );
		return { expr: EBlock(lines), pos: expr.pos };
	}
}
