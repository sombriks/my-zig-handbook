// my-project/src/root.zig
//! By convention, root.zig is the root source file when making a package.
const std = @import("std");
const _izEven = @import("iz_even");

pub const izEven = _izEven.izEven;

pub fn add(a: i8, b: i8) i8 {
    return a + b;
}
