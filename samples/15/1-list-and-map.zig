// 1-list-and-map.zig

const std = @import("std");

pub fn main(init: std.process.Init) !void {
    // some list operations
    var ints = try std.ArrayList(i32).initCapacity(init.gpa, 10);
    defer ints.deinit(init.gpa); // forces ints to be var instead of const
    std.log.info("Array of ints {any}", .{ints});
    for (1..15) |i| {
        try ints.append(init.gpa, @intCast(i));
    }
    std.log.info("Array of ints {any}", .{ints});
    _ = ints.orderedRemove(6);
    _ = ints.orderedRemove(6);
    _ = ints.orderedRemove(6);
    std.log.info("Array of ints {any}", .{ints});
    std.log.info("int[6] {}", .{ints.items[6]});
    _ = ints.pop();
    _ = ints.pop();
    _ = ints.pop();
    std.log.info("Array of ints {any}", .{ints});
    // now some map operations
    const MiscData = struct { age: u8, name: []const u8 };
    var map = std.StringHashMap(MiscData).init(init.gpa);
    defer map.deinit();
    try map.put("player1", .{ .age = 40, .name = "Sombriks" });
    std.log.info("Map entry for player1 {any}", .{map.get("player1")});
    try map.put("player2", .{ .age = 1, .name = "bot" });
    try map.put("player3", .{ .age = 1, .name = "bot 2" });
    try map.put("player4", .{ .age = 1, .name = "bot 3" });
    var it = map.iterator();
    while (it.next()) |entry| {
        std.log.info("Entry: {s} -> {any}", .{ entry.key_ptr.*, entry.value_ptr.* });
    }
}
