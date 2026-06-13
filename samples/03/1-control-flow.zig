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
