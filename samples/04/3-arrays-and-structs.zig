// 3-arrays-and-structs.zig

const std = @import("std");

const N1 = struct {
    fn foo(m: []const u8) void {
        std.log.info("N1.foo {s}",.{m});
    }
};

const N2 = struct {
    fn foo(m: []const u8) void {
        std.log.info("N2.foo {s}",.{m});
    }
};

const Vec3 = struct {
    x: i128 = 0,
    y: i128 = 0,
    z: i128 = 0,
    // a member function which read-only access
    fn inverse(v: Vec3) Vec3 {
        return Vec3{.x=-v.x, .y=-v.y, .z= -v.z};
    }
    // a member function able to change the instance
    fn invert(v: *Vec3) void {
        v.*.x = -v.*.x;
        v.*.y = -v.*.y;
        v.*.z = -v.*.z;
    }
    fn print(v:  *const Vec3) void {
        std.log.info("vector: {*}({},{},{})", .{v, v.*.x, v.*.y, v.*.z});
    }
};

pub fn main() void {
    // both functions has the same name
    N1.foo("bar");
    N2.foo("baz");
    var v1 = Vec3{.x=1};
    v1.print();
    // member functions
    var v2 = v1.inverse();
    v2.print();
    v1.invert();
    v1.print();
}
