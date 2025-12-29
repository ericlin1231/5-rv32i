extern var begin_signature: u32;
extern var end_signature: u32;

pub export var tohost: u32 linksection(".tohost") = 0;
pub export var fromhost: u32 linksection(".fromhost") = 0;

extern fn write_u32(ptr_ref: **volatile u32, val: u32) callconv(.c) void;

// R type bit operation
extern fn or_u32(ptr_ref: **volatile u32, operand_a: u32, operand_b: u32) callconv(.c) void;
extern fn and_u32(ptr_ref: **volatile u32, operand_a: u32, operand_b: u32) callconv(.c) void;
extern fn xor_u32(ptr_ref: **volatile u32, val: u32, times: u32) callconv(.c) void;
extern fn sra_u32(ptr_ref: **volatile u32, val: u32, shift_width: usize, times: u32) callconv(.c) void;
extern fn srl_u32(ptr_ref: **volatile u32, val: u32, shift_width: usize, times: u32) callconv(.c) void;
extern fn sll_u32(ptr_ref: **volatile u32, val: u32, shift_width: usize, times: u32) callconv(.c) void;

// I type bit operation
extern fn ori_u32(ptr_ref: **volatile u32, mask: u32) callconv(.c) void;
extern fn andi_u32(ptr_ref: **volatile u32, mask: u32) callconv(.c) void;
extern fn xori_u32(ptr_ref: **volatile u32, val: u32, times: u32) callconv(.c) void;
extern fn srai_u32(ptr_ref: **volatile u32, val: u32, times: u32) callconv(.c) void;
extern fn srli_u32(ptr_ref: **volatile u32, val: u32, times: u32) callconv(.c) void;
extern fn slli_u32(ptr_ref: **volatile u32, val: u32, times: u32) callconv(.c) void;

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

    const magic: u32 = 0xDEADBEEF;
    const sep: u32 = 0xAAAAAAAA;

    // or & ori operation
    var or_mask: u32 = magic;
    for (0..32) |_| {
        or_mask = or_mask >> 1;
        or_u32(&raw, 0x00000000, or_mask);
        // golden 1 - 32
    }
    write_u32(&raw, sep); // golden 33
    var ori_mask: u32 = magic;
    for (0..12) |_| {
        ori_mask = ori_mask >> 1;
        ori_u32(&raw, ori_mask); // ori_mask | 0 = ori_mask
        // golden 34 - 45
    }
    write_u32(&raw, sep); // golden 46
    // and & andi operation
    var and_mask: u32 = magic;
    for (0..32) |_| {
        and_mask = and_mask >> 1;
        and_u32(&raw, magic, and_mask);
        // golden 47 - 78
    }
    write_u32(&raw, sep);
    var andi_mask: u32 = magic;
    for (0..12) |_| {
        andi_mask = andi_mask >> 1;
        // andi_mask | -1 (sign_ext(0xFFF) = 0xFFFFFFFF)
        // so andi_mask after operation still is andi_mask
        andi_u32(&raw, andi_mask);
    }
    write_u32(&raw, sep);
    // xor self with same value for even times should has same value
    xor_u32(&raw, magic, 1024);
    write_u32(&raw, sep);
    xori_u32(&raw, magic, 1024); // imm is -273 = 0xEEF is last 3 byte of 0xDEADBEEF
    write_u32(&raw, sep);
    // shift right arithemetic 4 bit for 8 times
    sra_u32(&raw, magic, 4, 8);
    write_u32(&raw, sep);
    // shift right arithemetic 1 bit for 32 times
    srai_u32(&raw, magic, 32);
    write_u32(&raw, sep);
    // shift right logical 4 bit for 8 times
    srl_u32(&raw, magic, 4, 8);
    write_u32(&raw, sep);
    // shift right logical 1 bit for 32 times
    srli_u32(&raw, magic, 32);
    write_u32(&raw, sep);
    // shift left logical 4 bit for 8 times
    sll_u32(&raw, magic, 4, 8);
    write_u32(&raw, sep);
    // shift left logical 1 bit for 32 times
    slli_u32(&raw, magic, 32);
    write_u32(&raw, sep);

    spike_exit(1);
}
