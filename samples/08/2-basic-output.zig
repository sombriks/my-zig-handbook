// 2-basic-output.zig
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const cwd = std.Io.Dir.cwd();
    // let's produce some numbers
    var numbers: [100]i128 = undefined;
    for (&numbers, 0..) |*num, i| {
        num.* = @intCast(i * 5000); // Exemplo: 0, 5000, 10000, etc.
    }
    numbers[0]=55;
    numbers[99]=59;
    // prepare the file
    const file = try cwd.createFile(io, "numbers.bin", .{});
    defer file.close(io);
    // convert into bytes for write it correctly
    const bytes = std.mem.sliceAsBytes(&numbers);
    try file.writeStreamingAll(io, bytes);
}
