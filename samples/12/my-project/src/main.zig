// my-project/src/main.zig

const std = @import("std");
const my_project = @import("my_project");

pub fn main() void {
    const result = my_project.add(3, 3);
    std.log.info("is even {}",.{my_project.izEven(result)});
}
