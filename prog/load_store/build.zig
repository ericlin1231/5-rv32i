const std = @import("std");
const Target = std.Target;

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .riscv32,
        .os_tag = .freestanding,
        .abi = .ilp32,
        .cpu_model = .{ .explicit = &Target.riscv.cpu.generic_rv32 },
    });

    const optimize: std.builtin.OptimizeMode = .ReleaseSafe;

    const sim = addVariant(b, target, optimize, "sim");
    const spike = addVariant(b, target, optimize, "spike");

    b.getInstallStep().dependOn(sim.install_step);
    b.getInstallStep().dependOn(spike.install_step);

    const sim_step = b.step("sim", "Build and install sim variant only");
    sim_step.dependOn(sim.install_step);

    const spike_step = b.step("spike", "Build and install spike variant only");
    spike_step.dependOn(spike.install_step);
}

const VariantOut = struct {
    install_step: *std.Build.Step,
};

fn addVariant(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    ld_mode: []const u8,
) VariantOut {
    const root_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = b.fmt("load_store_{s}", .{ld_mode}),
        .root_module = root_module,
    });

    exe.entry = .disabled; // use self define entry _start
    exe.addAssemblyFile(b.path("../share/_start.s"));
    exe.addAssemblyFile(b.path("src/multi_load_u8.S"));

    const script_rel = b.fmt("../share/{s}_linker.ld", .{ld_mode});
    exe.setLinkerScript(b.path(script_rel));

    b.installArtifact(exe);

    const bin = b.addObjCopy(exe.getEmittedBin(), .{ .format = .bin });
    const install_bin = b.addInstallBinFile(
        bin.getOutput(),
        b.fmt("load_store_{s}.bin", .{ld_mode}),
    );

    const step = b.step(b.fmt("install_{s}", .{ld_mode}), "internal install step");
    step.dependOn(&exe.step);
    step.dependOn(&install_bin.step);

    return .{ .install_step = step };
}
