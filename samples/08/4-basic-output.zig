// 4-basic-output.zig

const std = @import("std");

pub const TodoItem = struct {
    description: [256]u8,
    done: bool,
};

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const cwd = std.Io.Dir.cwd();

    // 1. Prepare 10 TodoItems
    var todos: [10]TodoItem = undefined;
    for (&todos, 0..) |*item, i| {
        // Fill description with some text
        var desc: [256]u8 = @splat(0);
        const text = "Todo item number ";
        std.mem.copyForwards(u8, desc[0..text.len], text);
        desc[text.len] = @intCast('0' + i);

        item.* = .{
            .description = desc,
            .done = i % 2 == 0,
        };
    }

    // 2. Create the file todos.bin
    const file = try cwd.createFile(io, "todos.bin", .{});
    defer file.close(io);

    // 3. Serialize the array to bytes and write to file
    const bytes = std.mem.sliceAsBytes(&todos);
    try file.writeStreamingAll(io, bytes);

    std.log.info("Successfully serialized 10 TodoItems to todos.bin", .{});
}
