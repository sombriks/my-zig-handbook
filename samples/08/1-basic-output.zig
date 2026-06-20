// 1-basic-output.zig

const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const cwd = std.Io.Dir.cwd();
    const file = try cwd.createFile(io, "output.txt", .{});
    defer file.close(io);
    try file.writeStreamingAll(io, "Hello from Zig land!\n");
}
