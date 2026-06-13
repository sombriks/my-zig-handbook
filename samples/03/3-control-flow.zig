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
