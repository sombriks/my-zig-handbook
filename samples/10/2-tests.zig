// 2-tests.zig

const std = @import("std");

test "It should be true" {
    try std.testing.expect(2 == 5 - 3);
}

test "It should be equal" {
    try std.testing.expectEqual(@TypeOf(123),@TypeOf(321));
}

test "It should be same text" {
    try std.testing.expectEqualStrings("hello", "hello");
}
