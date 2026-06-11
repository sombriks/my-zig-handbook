// 2-hello-world.zig
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    //we need a context and a buffer to get a context writer
    const io = init.io;
    var buf: [1024]u8 = undefined;
    var writer = std.Io.File.stdout().writer(io, &buf);
    // finally, the stdout, write and flush the buffer
    const stdout = &writer.interface;
    try stdout.print("Hello {s}!\n", .{"World"});
    try stdout.flush();
}
