// 3-basic-output.zig
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const cwd = std.Io.Dir.cwd();
    // 1. Open the existing binary file for reading
    const file = try cwd.openFile(io, "numbers.bin", .{ .mode = .read_only });
    defer file.close(io);
    // 2. Prepare the destination array of 100 i128 elements
    var numbers: [100]i128 = undefined;
    // 3. Cast the destination memory area into a slice of raw bytes
    const buffer = std.mem.sliceAsBytes(&numbers);
    // wrap and cast it to the desired reading buffer geometry
    const wrap = @as([]const[]u8,&.{buffer});
    // 4. Read data sequentially until the buffer is completely filled
    // This expects exactly 1600 bytes (100 positions * 16 bytes each)
    const bytesRead =  try file.readStreaming(io, wrap);
    // 5. Verify the results by printing the first and last positions
    std.log.info("Bytes read: {}",.{bytesRead});
    std.log.info("Successfully loaded {d} i128 integers!", .{numbers.len});
    std.log.info("First number (index 0): {d}", .{numbers[0]});
    std.log.info("Last number (index 99): {d}", .{numbers[99]});
}
