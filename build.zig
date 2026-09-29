const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const libc_include = b.option(std.Build.LazyPath, "libc_include", "Build without libc against these headers; the consumer provides the symbols");

    const mod = b.createModule(.{ .target = target, .optimize = optimize, .link_libc = libc_include == null });
    if (libc_include) |p| mod.addIncludePath(p); // -I: must win over the macOS SDK headers zig always adds
    mod.addCSourceFile(.{ .file = b.path("minimp4.h"), .language = .c, .flags = &.{"-DMINIMP4_IMPLEMENTATION"} });

    const lib = b.addLibrary(.{ .name = "minimp4", .root_module = mod });
    lib.installHeader(b.path("minimp4.h"), "minimp4.h");
    b.installArtifact(lib);
}
