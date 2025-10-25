#include "Vmemory_test.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

static const uint64_t TIME_UNIT_PER_INC = 10;

static inline void half_step(
  Vmemory_test *top,
  VerilatedVcdC *tfp,
  VerilatedContext *context
)
{
    context->timeInc(TIME_UNIT_PER_INC);
    top->clk = !top->clk;
    top->eval();
    tfp->dump(context->time());
}

static inline void step(
  Vmemory_test *top,
  VerilatedVcdC *tfp,
  VerilatedContext *context
)
{
    half_step(top, tfp, context);
    half_step(top, tfp, context);
}

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv); 
    
    auto contextp = new VerilatedContext;
    contextp->traceEverOn(true);

    auto top = new Vmemory_test { contextp };
    auto tfp = new VerilatedVcdC;

    top->trace(tfp, 99); 
    tfp->open("wave.vcd");

    top->clk = 0;
    top->eval();
    tfp->dump(contextp->time());
    for (int i = 0; i < 10; i++) step(top, tfp, contextp);

    top->addr_i = 0x00000000;
    top->data_i = 0xDEADBEEF;
    step(top, tfp, contextp);
    top->wen = 1;
    half_step(top, tfp, contextp);
    top->eval();
    tfp->dump(contextp->time());
    half_step(top, tfp, contextp);
    top->wen = 0;
    top->eval();
    tfp->dump(contextp->time());
    for (int i = 0; i < 10; i++) step(top, tfp, contextp);

    top->addr_i = 0x00000000;
    step(top, tfp, contextp);
    top->ren = 1;
    half_step(top, tfp, contextp);
    top->eval();
    tfp->dump(contextp->time());
    half_step(top, tfp, contextp);
    top->ren = 0;
    top->eval();
    tfp->dump(contextp->time());
    for (int i = 0; i < 10; i++) step(top, tfp, contextp);
    

    top->final();
    tfp->close();
    delete tfp;
    delete top;
    delete contextp;

    return 0;
}
