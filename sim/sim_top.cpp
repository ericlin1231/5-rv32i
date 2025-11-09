#include "Vtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

static const uint64_t TIME_UNIT_PER_INC = 10;

static inline void half_step(
  Vtop *top,
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
  Vtop *top,
  VerilatedVcdC *tfp,
  VerilatedContext *context
)
{
    half_step(top, tfp, context);
    half_step(top, tfp, context);
}

int main(int argc, char **argv)
{
    auto contextp = new VerilatedContext;
    contextp->commandArgs(argc, argv);
    contextp->traceEverOn(true);

    auto top = new Vtop { contextp };
    auto tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("wave.vcd");

    top->clk = 0;
    top->rst_n = 0;
    top->eval();
    tfp->dump(contextp->time());
    for (int i = 0; i < 10; i++) step(top, tfp, contextp);

    half_step(top, tfp, contextp);
    top-> rst_n = 1;
    half_step(top, tfp, contextp);
    top->eval();
    tfp->dump(contextp->time());
    for (int i = 0; i < 100; i++) step(top, tfp, contextp);

    top->final();
    tfp->close();
    delete tfp;
    delete top;
    delete contextp;

    return 0;
}
