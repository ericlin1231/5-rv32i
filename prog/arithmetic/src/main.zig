extern var begin_signature: u32;
extern var end_signature: u32;

pub export var tohost: u32 linksection(".tohost") = 0;
pub export var fromhost: u32 linksection(".fromhost") = 0;

extern fn write_u32(ptr_ref: **volatile u32, val: u32) callconv(.c) void;

extern fn add_u32(ptr_ref: **volatile u32, operand_a: u32, operand_b: u32) callconv(.c) void;
extern fn addi_u32(ptr_ref: **volatile u32, val: u32) callconv(.c) void;
extern fn sub_u32(ptr_ref: **volatile u32, operand_a: u32, operand_b: u32) callconv(.c) void;

fn spike_exit(status: u32) noreturn {
    tohost = status;
    while (true) {}
}

pub export fn main() linksection(".text.main") noreturn {
    const start: usize = @intFromPtr(&begin_signature);
    const end: usize = @intFromPtr(&end_signature);
    const word_cnt: u32 = (end - start) / @sizeOf(u32);
    _ = word_cnt;

    var raw: *volatile u32 = @as(*volatile u32, @ptrFromInt(start));
    const sep: u32 = 0xAAAAAAAA;

    // add operation
    add_u32(&raw, 0xFFFFFFFF, 1); // overflow
    write_u32(&raw, sep);
    add_u32(&raw, 0xD0A0B0E0, 0x0E0D0E0F); // 0xDEADBEEF
    write_u32(&raw, sep);
    // addi operation +1
    addi_u32(&raw, 0xFFFFFFFF); // overflow
    write_u32(&raw, sep);
    // sub operation
    sub_u32(&raw, 0, 1); // underflow
    write_u32(&raw, sep);

    spike_exit(1);
}
