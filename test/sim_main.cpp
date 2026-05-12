#include "Vcounter.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vcounter* dut = new Vcounter;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    dut->trace(tfp, 99);
    tfp->open("counter.vcd");

    dut->rst = 1; dut->clk = 0;
    for (int i = 0; i < 40; i++) {
        dut->clk = !dut->clk;
        if (i == 4) dut->rst = 0;
        dut->eval();
        tfp->dump(i);
    }
    tfp->close();
    delete dut;
    std::cout << "Simulation complete. Open counter.vcd in GTKWave." << std::endl;
    return 0;
}
