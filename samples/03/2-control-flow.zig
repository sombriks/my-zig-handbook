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
