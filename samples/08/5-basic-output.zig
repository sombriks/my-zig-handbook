// 5-basic-output.zig

const std = @import("std");
const sample = @import("4-basic-output.zig");
const TodoItem = sample.TodoItem;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const cwd = std.Io.Dir.cwd();

    // 1. Open the existing binary file for reading
    const file = try cwd.openFile(io, "todos.bin", .{ .mode = .read_only });
    defer file.close(io);

    // 2. Prepare the destination array of 10 TodoItem elements
    var todos: [10]TodoItem = undefined;

    // 3. Cast the destination memory area into a slice of raw bytes
    const buffer = std.mem.sliceAsBytes(&todos);
    // wrap and cast it to the desired reading buffer geometry
    const wrap = @as([]const []u8, &.{buffer});

    // 4. Read data sequentially until the buffer is completely filled
    const bytesRead = try file.readStreaming(io, wrap);

    // 5. Verify the results by printing the items
    std.log.info("Bytes read: {}", .{bytesRead});
    std.log.info("Successfully loaded {d} TodoItems!", .{todos.len});

    for (todos, 0..) |item, i| {
        // Find the actual end of the description string (null-terminated)
        const desc_len = std.mem.indexOfScalar(u8, &item.description, 0) orelse item.description.len;
        const description = item.description[0..desc_len];
        std.log.info("Item {d}: description='{s}', done={}", .{ i, description, item.done });
    }
}

