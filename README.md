ObjectInit
==========

A very simple Haxe macro for helping to initialise objects with lots of properties, without writing giant constructors.

### Usage

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

### Quoted field names

Quoted field names are not supported.

For example:

```haxe
var p = new Project().init({
	"name": "ObjectInit", // Error: Project has no field @$__hx__name
	"downloads": 1000000, // Error: Project has no field @$__hx__downloads
	"tags": ["macro","helper"] // Error: Project has no field @$__hx__tags
});
```

See [Haxe Issue 2642](https://github.com/HaxeFoundation/haxe/issues/2642) for details.

### Naming conflicts

If your object already has a method called `init()`, then you can use the `initObject` alias instead:

    new Project().initObject({ ... });

In the unlikely event that both names are taken, you could do:

    ObjectInit.init( new Project(), { ... } );

### Installation

    haxelib install objectinit

### License

Code released into the Public Domain.

Contributions welcome.
