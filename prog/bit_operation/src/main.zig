extern var begin_signature: usize;
extern var end_signature: usize;

pub export var tohost: u32 linksection(".tohost") = 0;
pub export var fromhost: u32 linksection(".fromhost") = 0;

fn spike_exit(status: u32) noreturn {
    tohost = status;
    while (true) {}
}

pub export fn main() noreturn {
    const start: usize = @intFromPtr(&begin_signature);
    const end: usize = @intFromPtr(&end_signature);
    const len_words: usize = (end - start) / @sizeOf(u32);

    const raw: [*]volatile u32 = @as([*]volatile u32, @ptrFromInt(start));
    const p: []volatile u32 = raw[0..len_words];
    // p[0] = 0xDEADBEEF;
    // var idx: usize = 0;

    var val: u32 = 0xDEADBEEF;
    const xor_operand: u32 = 0xDEADBEEF;
    val ^= xor_operand;
    val ^= xor_operand;
    for (0..4) |i| {
        p[i] = val;
        val = val >> 4;
    }

    // for (0..9) |_| val ^= xor_operand;

    // p[idx] = val;
    // idx += 1;

    spike_exit(1);
}
