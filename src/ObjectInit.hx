import haxe.macro.Expr;
import haxe.macro.Context;
using haxe.macro.ExprTools;

/**
A helper utility to initialize variables on objects without giant setters/getters.

An example, using a pretend model `Project`:

```haxe
using ObjectInit;

// Writing one of these:
var p = new Project().init({ name:"ObjectInit", downloads:1000000, tags:["macro","helper"] });
var p = new Project().init( name="ObjectInit", downloads=1000000, tags=["macro","helper"] );

// Is the same as writing:
var p = new Project();
p.name = "ObjectInit";
p.downloads = 1000000;
p.tags = ["macro","helper"];

// You can even use it in a function call:
uploadProject( new Project().init({ name:"ObjectInit", downloads:1000000, tags:["macro","helper"] }) );
uploadProject( new Project().init(name="ObjectInit", downloads=1000000, tags=["macro","helper"]) );

// If you have local variables with the same name as the target property, you can just use the variable name:
var name = "ObjectInit";
var downloads = 1000000;
var tags = ["macro","helper"];
var p = new Project().init( name, downloads, tags );

// Or like this:
function addProject( name:String, downloads:Int, tags:Array<String> ) {
	return new Project().init( name, downloads, tags ).save();
}
```

It runs as a macro, so it's type safe.  In the example above, `new Project().init({ downloads:"not-a-number" })` would fail to compile, because of the incorrect type.
**/
class ObjectInit {
	macro public static function init<T>( expr:ExprOf<T>, varsToSet:Array<Expr> ):ExprOf<T> {
		return doTransformation( expr, varsToSet, "init" );
	}

	/** An alias for `init()`, in case you need to use it on an object which already has a method called `init()`. **/
	macro public static function objectInit<T>( expr:ExprOf<T>, varsToSet:Array<Expr> ):ExprOf<T> {
		return doTransformation( expr, varsToSet, "objectInit" );
	}

	/** An alias for `init()`, in case you need to use it on an object which already has a method called `init()`. **/
	macro public static function initObject<T>( expr:ExprOf<T>, varsToSet:Array<Expr> ):ExprOf<T> {
		return doTransformation( expr, varsToSet, "initObject" );
	}

	#if macro
		static function doTransformation<T>( expr:ExprOf<T>, args:Array<Expr>, fnName:String ):ExprOf<T> {
			var lines:Array<Expr> = [];
			lines.push( macro var __obj_init_tmp = $expr );
			for ( varsToSet in args ) {
				addExpr( varsToSet, lines, fnName );
			}
			lines.push( macro @:pos(expr.pos) __obj_init_tmp );
			return { expr: EBlock(lines), pos: expr.pos };
		}

		static function addExpr( varsToSet:Expr, lines:Array<Expr>, fnName:String ) {
			switch varsToSet {
				case macro $i{varName}:
					addLine( varName, varsToSet, lines );
				case macro $i{varName} = $value:
					addLine( varName, value, lines );
				case macro [$a{exprs}]:
					for ( expr in exprs )
						addExpr( expr, lines, fnName );
				case { expr:EObjectDecl(fields), pos:_ }:
					for ( field in fields )
						addLine( field.field, field.expr, lines );
				case other: Context.error( '$fnName() arguments should be `variable`, `varName=varValue`, `{ varName:varValue }` or a combination of these.', varsToSet.pos );
			}
		}

		static function addLine( varName:String, varValue:Expr, lines:Array<Expr> ) {
			lines.push( macro @:pos(varValue.pos) __obj_init_tmp.$varName = $varValue );
		}
	#end
}
