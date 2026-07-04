// src/root.zig

pub const c = @cImport({
    @cInclude("my-c-thing.h");
});
