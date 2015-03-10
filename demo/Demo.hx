using ObjectInit;

class Demo {
	static function main() {
		// Writing this:
		var p = new Project().init({ name:"ObjectInit", downloads:1000000, tags:["macro","helper"] });
		uploadProject( p );

		// Is the same as writing:
		var p = new Project();
		p.name = "ObjectInit";
		p.downloads = 1000000;
		p.tags = ["macro","helper"];
		uploadProject( p );

		// You can even use it in a function call:
		uploadProject( new Project().init({ name:"ObjectInit", downloads:1000000, tags:["macro","helper"] }) );

		// If you have local variables with the same name as the target property, you can use an array to initialise:
		var name = "ObjectInit";
		var downloads = 1000000;
		var tags = ["macro","helper"];
		var p = new Project().init([ name, downloads, tags ]);
		uploadProject( p );

		// If your object has an init method, you can use one of these too:
		var p = new Project().initObject({ name:"ObjectInit", downloads:1000000, tags:["macro","helper"] });
		var p = new Project().objectInit({ name:"ObjectInit", downloads:1000000, tags:["macro","helper"] });
		var p = new Project().initObject([ name, downloads, tags ]);
		var p = new Project().objectInit([ name, downloads, tags ]);
	}

	static function uploadProject( p:Project ) {
		if ( p.name!="ObjectInit" )
			throw 'Expected name to be "ObjectInit"';
		if ( p.downloads!=1000000 )
			throw 'Expected downloads to be 1,000,000';
		if ( p.tags.length!=2 )
			throw 'Expected there to be 2 tags';
		trace( 'That object was okay' );
	}
}

class Project {
	public function new() {}
	public var name:String;
	public var downloads:Int;
	public var tags:Array<String>;
}