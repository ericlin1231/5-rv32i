extern var begin_signature: usize;
extern var end_signature: usize;

pub export fn main() noreturn {
    const start = @intFromPtr(&begin_signature);
    const end   = @intFromPtr(&end_signature);
    const len_words: usize = (end - start) / @sizeOf(u32);

    const raw = @as([*]volatile u32, @ptrFromInt(start));
    const p: []volatile u32 = raw[0..len_words];

    var i: usize = 0;
    while (i < p.len) : (i += 1) {
        p[i] = 0xDEADBEEF;
    }

    while (true) {}
}

