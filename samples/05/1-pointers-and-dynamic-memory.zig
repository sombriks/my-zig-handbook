// 1-pointers-and-dynamic-memory.zig

const std = @import("std");
const info = std.log.info;

pub fn main() void {
    // general purpose allocator
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();
    var data = allocator.alloc(u128, 100) catch unreachable;
    for (0..100) |i| {
        data[i] = i;
    }
    std.log.info("data: {any}", .{data});
    // oops, forgot to free
    // allocator.free(data);
}
