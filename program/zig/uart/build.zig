const std = @import("std");
const Target = std.Target;

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .riscv32,
        .os_tag = .freestanding,
        .abi = .ilp32,
        .cpu_model = .{ .explicit = &Target.riscv.cpu.generic_rv32 },
    });

    const exe = b.addExecutable(.{
        .name = "rodata_to_stack",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = .ReleaseSafe,
        }),
    });

    exe.entry = .disabled; // use self define entry _start
    exe.addAssemblyFile(b.path("src/_start.s"));
    exe.setLinkerScript(b.path("src/linker.ld"));

    b.installArtifact(exe);

    const bin = b.addObjCopy(exe.getEmittedBin(), .{ .format = .bin });
    const install_bin = b.addInstallBinFile(bin.getOutput(), "rodata_to_stack.bin");
    b.getInstallStep().dependOn(&install_bin.step);
}

