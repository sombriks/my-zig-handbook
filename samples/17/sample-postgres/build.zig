const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // 1 - configure the downloaded dependency as a module
    const pg_module = b.dependency("pg", .{}).module("pg");

    const mod = b.addModule("sample_postgres", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        // 2 - register the library odule as an import
        .imports = &.{
            .{ .name = "pg", .module = pg_module },
        },
    });

    const exe = b.addExecutable(.{
        .name = "sample_postgres",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            // 2 - register the library module as an import
            .imports = &.{
                .{ .name = "sample_postgres", .module = mod },
                .{ .name = "pg", .module = pg_module },
            },
        }),
    });
    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addRunArtifact(exe);

    run_step.dependOn(&run_cmd.step);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

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

    // 3 - bonus: start the docker compose from zig build
    const run_db_cmd = b.addSystemCommand(&.{
        "docker", "compose", "-f", "infra/database.yml", "up", "-d",
    });
    const db_step = b.step("db", "Start the local development database");
    db_step.dependOn(&run_db_cmd.step);
}
