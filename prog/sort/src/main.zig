extern var begin_signature: u32;
extern var end_signature: u32;

pub export var tohost: u32 linksection(".tohost") = 0;
pub export var fromhost: u32 linksection(".fromhost") = 0;

pub export const arr_init: [9]u32 linksection(".rodata.arr_init") = .{ 8, 7, 6, 5, 4, 3, 2, 1, 0 };

fn spike_exit(status: u32) noreturn {
    tohost = status;
    while (true) {}
}

pub export fn main() linksection(".text.main") noreturn {
    const start: usize = @intFromPtr(&begin_signature);
    const end: usize = @intFromPtr(&end_signature);
    const word_cnt: u32 = (end - start) / @sizeOf(u32);
    _ = word_cnt;

    const ptr: [*]u32 = @as([*]u32, @ptrFromInt(start));
    var arr: [9]u32 = arr_init;

    for (arr, 0..arr.len) |_, idx1| {
        var min_idx = idx1;
        for (arr[(idx1 + 1)..], (idx1 + 1)..arr.len) |item2, idx2| {
            if (arr[min_idx] > item2) {
                min_idx = idx2;
            }
        }
        if (min_idx != idx1) {
            const tmp = arr[min_idx];
            arr[min_idx] = arr[idx1];
            arr[idx1] = tmp;
        }
    }
    for (arr, 0..arr.len) |item, idx| ptr[idx] = item;

    spike_exit(1);
}
