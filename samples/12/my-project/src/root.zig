//! By convention, root.zig is the root source file when making a package.
const std = @import("std");
const _izEven = @import("iz_even");

pub const izEven = _izEven.izEven;

pub fn add(a: i32, b: i32) i32 {
    return a + b;
}
