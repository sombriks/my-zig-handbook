# [my-zig-handbook][repo]

[repo]: https://github.com/sombriks/my-zig-handbook

My study notes on [Zig][Zig], the _better than C_ programming language.

[Zig]: https://ziglang.org

## Agenda

- Introduction
- Installation
- Hello World
- Basic Types
- Control Flow
- Structs
- Functions
- Basic Input
- Basic Output (Files)
- Error Handling
- Tests
- Pointers
- Generic Types
- Project Setup
- Libraries
- Threads
- Networking
-

## Introduction

Over the years i studied a few languages in order to have fun and to pay my 
rent.

Get into computers, like any other career, is lie joining an ongoing party: a 
lot is happening, a lot already happened, no real need to understand everything
but you start to get it, over the time, little by little.

At first i learned [java][java], like everyone else. Then 
[javascript][javascript], because technologic limitations in the client. Then 
[sql][sql]. Then [C++][cpp]. And so on.

[java]: https://dev.java
[javascript]: https://developer.mozilla.org/docs/Web/JavaScript
[sql]: https://learnsql.com
[cpp]: https://cppreference.com/

Each language, along with its associated runtimes and ecosystems, had an 
specific target problem. And over the years i started to figure out what tool 
best suites the current problem.

This skill also evolved into the intuition of what skill should i master in 
order to proper solve a problem.

So here we are, looking at another nice tool to add into the tool belt.

### Why Zig?

In a world full of good hammers, why choose a new one? Are the old tools 
broken, inefficient or something?

Mot really, in fact fact the hammers aren't the problem. The nails that keeps
changing.

Once a problem is solved, new objectives emerges and life goes on. Therefore 
it's natural to keep checking on new ways to solve problems.

Bu old tools doesn't get automatically unusable. In fact, there are lots of 
solutions written in java that i am still willing to maintain. Several problems 
that i still consider to use [golang][golang] if i have the opportunity, and 
would still choose [vue][vue] over [htmx][htmx], depending on the context. It is
a matter of best possible combination of tools for a given problem.

[golang]: https://golang.org
[vue]: https://vuejs.org
[htmx]: https://htmx.org

That said, where do i think that Zig fits?

The language promises **performance**, **developer experience** and an 
impressive **C interoperability**. It also doubles as a **robust build system**,
compatible with existing codebases.

The C ABI compatibility also is an interesting offer, because it opens to zig
Projects a wide range of library options, ready to use.

So, at first, zig looks like a nice option to write code to run in de 
middleware, between a client application and a database or a specialized 
system, assuming the scenario of usual enterprise solutions. Of course, zig 
promises also systems, low-level, cross-platform and embedded capabilities, and
that would be cool to explore as well.

The language also offers a solid development philosophy. No hidden flows. No 
implicit allocations/deallocations. All must be expressed in an explicit way. 

Because of this, careless memory management can be captured at compile time, 
getting rid of a whole class of bugs possible in C or C++ projects.

The manual memory management also means that, unlike java or golang, the code 
is highly predictable, no gc pauses to clean things up.

The explicitness baked in zig also mean that there is no such thing as higher 
abstractions like classes or function overloading. In fact, the language 
relates more C or rust instead of java, golang or C++.

This does not mean that zig has little expressiveness. in fact, concepts like 
[generics][generics], [null-safe][null-safe] operations, sophisticated 
[error handling][error handling], even [reflection][reflection] are 
available as key parts of the language.

[generics]: https://devdocs.io/zig/index#Generic-Data-Structures
[null-safe]: https://devdocs.io/zig/index#Optionals
[error handling]: https://devdocs.io/zig/index#Errors
[reflection]: https://ziglang.org/documentation/master/#Function-Reflection

Moreover, in zig is straightforward the use of C libraries, opening a rich 
ecosystem ecosystem from day zero of any project.

Zig also doubles as a build system, where the build script is written in zig 
itself, and given the high portability and ease of installation of its 
runtime, makes it an ideal tool for projects that not necessarily are zig 
projects: remember, zig is also a C compiler.

## Installation

Since i am running [fedora][fedora], all i need to do to get zig into my system 
is:

```bash
sudo dnf install zig
```

[fedora]: https://getfedora.org

One extra tool that will help is the the [zls][zls], a language server to the 
language, so ypu get autocomplete working in lightweight text editors, such as 
[kate][kate].

[zls]: https://github.com/zigtools/zls
[kate]: https://apps.kde.org/pt-br/kate/

## Hello World

So, let's say hello:

```zig
// 1-hello-world.zig
const std = @import("std");

pub fn main() void {
    std.log.info("Hello world!",.{});
}
```

To execute this, simply run:

```bash
zig run 1-hello-world.zig
```

For proper compilation, call it with `build-exe`:

```bash
zig build-exe 1-hello-world.zig
./1-hello-world
```

This hello world has nothing special, except for the use of the built-in log 
library instead of direct use of standard output stream. So it's closer to a 
[node.js][node.js] hello world than a C hello world.

[node.js]: https://nodejs.org

An alternative, more closer to native languages would be like this:

```zig
// 2-hello-world.zig
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    //we need a context and a buffer to get a writer
    const io = init.io;
    var buf: [1024]u8 = undefined;
    var writer = std.Io.File.stdout().writer(io, &buf);
    // finally, the stdout, write and flush the buffer
    const stdout = &writer.interface;
    try stdout.print("Hello {s}!\n", .{"World"});
    try stdout.flush();
}

```

_So, what is happening here? I just wanted a hello world!_

Instead, the design choice of be highly explicit surfaces:

- The standard output belongs to the IO subsystem
- We need a writer interface, and write operations are commonly buffered
- We need to flush the writer buffer to the stream

it affected even the main function signature, demanding it to be more explicit 
about the possible errors.

A third option is this one:

```zig
// 3-hello-world.zig
const std = @import("std");

pub fn main() void {
    std.debug.print("Hello world!\n",.{});
}
```

In short, explicitness does not need to translate in complexity.

## Basic types

Types are powerful expression features in every language. Thanks to them, you 
don't need to track yourself memory offsets. Remember, the memory is just a 
glorified list of bits, often grouped in chunks of bytes.

This is why the type names in zig are as explicit as possible.

### Integers

Basic integers follows: `i8`, `i16`, `i32`, `i64` and `i128`. Those types can 
hold the entire range of positive and negative numbers possible to represent 
using the number of bytes presented after the _i_ letter.

If you need to represent only positive integers, then the types are `u8`,`u16`, 
`u32`, `u64` and `u128`.

### Floating point number

You guessed: `f8`, `f16`, `f32`, `f64` and `f128`.

### Boolean

Just one bit, but here you write `true` or `false`.

### Custom bit sizes

Another interesting feature of zig's type system is custom sized types. For 
example, let's represent a type able to hold **8** distinct values. To make it 
sol, all you need is **3 bits**, so declare `var x: u3 = 0;` is a complete 
valid statement.

### Small tour on types

Below a small sample on how those types behave:

```zig
// 1-sample-types.zig

pub fn main() u8 {
    const std = @import("std"); // valid code!
    var x: u8 = 255;
    std.log.debug("x value: {}", .{x});
    std.log.debug("x type: {}", .{@TypeOf(x)});// reflection!
    std.log.debug("x size: {}", .{@sizeOf(u8)}); // size in bytes
    x +%= 1; // overflow-aware add operator
    // a bigger variable
    var y: i16 = 255;
    std.log.debug("y value: {}", .{y});
    std.log.debug("y type: {}", .{@TypeOf(y)});
    std.log.debug("y size: {}", .{@sizeOf(i16)});
    y += 1; // no need to worry about overflows for now
    std.log.debug("y value: {}", .{y});
    // now some jazz
    var z: u3 = 0;
    std.log.debug("z value: {}", .{z});
    std.log.debug("z type: {}", .{@TypeOf(z)});
    std.log.debug("z size: {}", .{@sizeOf(u3)});
    z +%= 1;
    std.log.debug("z value: {}", .{z});
    z +%= 2;
    std.log.debug("z value: {}", .{z});
    z +%= 4;
    std.log.debug("z value: {}", .{z});
    z +%= 6;
    std.log.debug("z value: {}", .{z}); // surprise!
    return x; // returns 0
}
```

## Control Flow

In zig, control flow is pretty straightforward, with a few improvemente when 
compared with C.

### Conditionals

`if` statements are straightforward, with some neat [unboxing][unboxing] 
features:

[unboxing]: https://zig.guide/language-basics/optionals/

```zig
// 1-control-flow.zig
const std = @import("std");
const print = std.debug.print;

pub fn main() void {
    // classic conditional
    if(true) print("This happens\n",.{});
    if(false) print("This never happens\n",.{});
    // conditional expression (ternary operator replacement)
    var x: u8 = if(true) 2 else 4;
    print("x: {}\n", .{x});
    x+=1;
    x = if (x % 2 == 0) 4 else 7;
    print("x: {}\n", .{x});
    // unwrapping optional
    // if a variable can assume null values, the type must make it explicit:
    var yMaybe: ?u8 = null;
    // conditionals can check for the value presence
    if (yMaybe) |y| {
        print("This never happens {}\n", .{y});
    }
    yMaybe = 10;
    if (yMaybe) |y| {
        print("This optional has value {}\n", .{y});
    }
}
```

`switch` statements:

```zig
// 2-control-flow.zig

const std = @import("std");
const print = std.debug.print;

pub fn main() void {
    const number = 1221;
    // switch as statement
    switch(number) {
        // specific value
        1 => print("is that really random?\n",.{number}),
        // possible values
        2,3,4,5 => print("not my options.\n",.{number}),
        // value range
        10...30 => print("not my range.\n",.{number}),
        // mix things, blocks are allowed too
        0, 31...51 => {
            print("this is a big number.\n",.{number});
            print("it is.\n", .{});

        },
        else => print("and everything else\n", .{})
    }

    // switch as expressions
    const status: u16 = 404;
    const message = switch (status) {
        200 => "Success",
        401 => "Unauthorized",
        404 => "Not Found",
        else => "Unknown Status",
    };
    print("message: {s}\n", .{message});
}
```

### Loops

`while` statements / expressions:

```zig
// 3-control-flow.zig
const std = @import("std");

pub fn main() void {
    // lawful good
    var i: u8 = 1;
    while (i <= 5) {
        std.log.info("i : {}", .{i});
        i += 1;
    }
    // true neutral
    var j: u8 = 5;
    while(j > 0) : (j -= 1) {
        std.log.info("j : {}", .{j});
    }
    // chaotic evil
    var k: u8 = 0;
    const f: u8 = while(k < 50) : (k = k + 3) {
        if (k > 10) break k;
    } else 4;
    std.log.info("k : {}, f: {}", .{k,f});
}
```

`for` statements:

```zig
// 4-control-flow.zig
```
