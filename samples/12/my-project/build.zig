const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // configuring fetched package
    const iz_even_dep = b.dependency("iz_even", .{
        .optimize = optimize,
        .target = target
    });

    // default project module
    const mod = b.addModule("my_project", .{
        .root_source_file = b.path("src/root.zig"),
        .optimize = optimize,
        .target = target
    });
    mod.addImport("iz_even", iz_even_dep.module("iz_even"));

    // simple project executable
    const exe = b.addExecutable(.{
        .name = "my_project",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "my_project", .module = mod },
            },
        }),
    });
    b.installArtifact(exe);

    // custom step - run executable, passing args through
    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // custom step - run tests
    const mod_tests = b.addTest(.{
        .root_module = mod,
    });
    const run_mod_tests = b.addRunArtifact(mod_tests);
    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
    });
    const run_exe_tests = b.addRunArtifact(exe_tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
    test_step.dependOn(&run_exe_tests.step);
}
