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

	// If you have local variables with the same name as the target property, you can use an array to initialise:
	var name = "ObjectInit";
	var downloads = 1000000;
	var tags = ["macro","helper"];
	var p = new Project().init([ name, downloads, tags ]);
	```

	It runs as a macro, so it's type safe.  In the example above, `new Project().init({ downloads:"not-a-number" })` would fail to compile, because of the incorrect type.
**/
class ObjectInit {
	macro public static function init<T>( expr:ExprOf<T>, varsToSet:Expr ):ExprOf<T> {
		return doTransformation( expr, varsToSet, "init" );
	}

	/** An alias for `init()`, in case you need to use it on an object which already has a method called `init()`. **/
	macro public static function objectInit<T>( expr:ExprOf<T>, varsToSet:Expr ):ExprOf<T> {
		return doTransformation( expr, varsToSet, "objectInit" );
	}

	/** An alias for `init()`, in case you need to use it on an object which already has a method called `init()`. **/
	macro public static function initObject<T>( expr:ExprOf<T>, varsToSet:Expr ):ExprOf<T> {
		return doTransformation( expr, varsToSet, "initObject" );
	}

	#if macro
		static function doTransformation<T>( expr:ExprOf<T>, varsToSet:Expr, fnName:String ):ExprOf<T> {
			var lines:Array<Expr> = [];
			lines.push( macro var __obj_init_tmp = $expr );
			switch varsToSet.expr {
				case EObjectDecl(fields):
					for ( field in fields ) {
						var varName = field.field;
						var varValue = field.expr;
						lines.push( macro __obj_init_tmp.$varName = $varValue );
					}
				case EArrayDecl(values):
					for ( valExpr in values ) {
						switch valExpr.expr {
							case EConst(CIdent(varName)):
								lines.push( macro __obj_init_tmp.$varName = $valExpr );
							case other:
								Context.error( 'Expected $fnName() argument to be an array declaration containing only simple variable names, so "${valExpr.toString()}" is not supported', valExpr.pos );
						}
					}
				case other: Context.error( 'Expected $fnName() argument to be an object declaration { name: value } or an array declaration [ namedVal1, namedVal2 ]', expr.pos );
			}
			lines.push( macro __obj_init_tmp );
			return { expr: EBlock(lines), pos: expr.pos };
		}
	#end
}
