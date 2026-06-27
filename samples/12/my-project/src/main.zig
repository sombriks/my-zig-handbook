// my-project/src/main.zig

const std = @import("std");
const my_project = @import("my_project");

pub fn main() void {
    const a: i8 = 3;
    const b: i8 = 3;
    const result: i8 = my_project.add(a, b);
    std.log.info("is even {}",.{my_project.izEven(result)});
}
