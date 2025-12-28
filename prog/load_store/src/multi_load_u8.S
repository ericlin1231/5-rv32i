.section .text
.globl multi_load_store_u8
.type multi_load_store_u8, @function

/* usage:
 * run 2 round multiple load store byte test
 * each round:
 *   load 4 byte to register at same time
 *   store 4 byte to destination at same time
 */

/* a0: src: *u8
 * a1: dest: **u8
 */

multi_load_store_u8:
    // load destination address
    lw t0, 0(a1)
    // load first round 4 byte
    lb t1, 0(a0)
    lb t2, 1(a0)
    lb t3, 2(a0)
    lb t4, 3(a0)
    // store first round 4 byte
    sb t1, 0(t0)
    sb t2, 1(t0)
    sb t3, 2(t0)
    sb t4, 3(t0)
    // load second round 4 byte
    lb t1, 4(a0)
    lb t2, 5(a0)
    lb t3, 6(a0)
    lb t4, 7(a0)
    // store second round 4 byte
    sb t1, 4(t0)
    sb t2, 5(t0)
    sb t3, 6(t0)
    sb t4, 7(t0)
    ret