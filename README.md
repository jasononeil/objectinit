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
```

It runs as a macro, so it's type safe.  In the example above, `new Project().init({ downloads:"not-a-number" })` would fail to compile, because of the incorrect type.

### Installation

    haxelib install objectinit

### License

Code released into the Public Domain.

Contributions welcome.
