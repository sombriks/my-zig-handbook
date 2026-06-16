// 2-basic-input.zig
const std = @import("std");

pub fn main(init: std.process.Init) void {
    const args = init.minimal.args.vector;
    std.log.info("number of arguments: {}",.{args.len});
    for(args) |arg| std.log.info("{s}",.{arg});
}
