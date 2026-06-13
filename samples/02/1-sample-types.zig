// 1-sample-types.zig

pub fn main() u8 {
    const std = @import("std"); // valid code!
    var x: u8 = 255;
    std.log.debug("x value: {}", .{x});
    std.log.debug("x type: {}", .{@TypeOf(x)});// reflection!
    x +%= 1; // overflow operator
    return x; // returns 0
}
