// 2-arrays-and-structs.zig

const std = @import("std");

// basic declaration
const TodoItem = struct { description: []const u8, done: bool = false };

pub fn main() void {
    var item1 = TodoItem{ .description = "walk the dog" };
    const item2 = TodoItem{ .description = "wash dishes", .done = true };
    std.log.info("item 1 {s}, {}", .{ item1.description, item1.done });
    std.log.info("item 2 {s}, {}", .{ item2.description, item2.done });
    const item3 = item1; // copy value
    item1.done = true;
    std.log.info("item 1 {s}, {}", .{ item1.description, item1.done });
    std.log.info("item 3 {s}, {}", .{ item3.description, item3.done });
    std.log.info("item 3 type: {}", .{@TypeOf(item3)});
    std.log.info("item 3 size: {}", .{@sizeOf(@TypeOf(item3))});
    std.log.info("item 2 size: {}", .{@sizeOf(@TypeOf(item2))});
    std.log.info("item 1 size: {}", .{@sizeOf(@TypeOf(item1))});
    // coercion
    const item4: TodoItem = .{ .description = "read a book" };
    std.log.info("item 4 {s}, {}", .{ item4.description, item4.done });
    // tuples, kinda arbitrary list values
    const stuff = .{1, "foo", 0o55, 0b11010001, 0xAE, item4, @TypeOf(item2)};
    std.log.info("stuff: {any}", .{ stuff });
}
