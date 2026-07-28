#include "Vregfile.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

void tick(Vregfile* dut, VerilatedVcdC* tfp, int& time) {
    dut->clk = 0; dut->eval(); tfp->dump(time++);
    dut->clk = 1; dut->eval(); tfp->dump(time++);
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vregfile* dut = new Vregfile;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    dut->trace(tfp, 99);
    tfp->open("regfile.vcd");

    int t = 0;
    dut->we = 0; dut->rs1 = 0; dut->rs2 = 0;
    dut->rd = 0; dut->wd = 0;
    tick(dut, tfp, t);

    // Write 42 into register x1
    dut->we = 1; dut->rd = 1; dut->wd = 42;
    tick(dut, tfp, t);

    // Write 100 into register x2
    dut->rd = 2; dut->wd = 100;
    tick(dut, tfp, t);

    // Write 999 into register x15
    dut->rd = 15; dut->wd = 999;
    tick(dut, tfp, t);

    // Read back x1 and x2
    dut->we = 0; dut->rs1 = 1; dut->rs2 = 2;
    tick(dut, tfp, t);
    std::cout << "rd1 (expect 42):  " << dut->rd1 << std::endl;
    std::cout << "rd2 (expect 100): " << dut->rd2 << std::endl;

    // Read back x15 and x0 (x0 must always be 0)
    dut->rs1 = 15; dut->rs2 = 0;
    tick(dut, tfp, t);
    std::cout << "rd1 (expect 999): " << dut->rd1 << std::endl;
    std::cout << "rd2 (expect 0):   " << dut->rd2 << std::endl;

    // Try writing to x0 — should be ignored
    dut->we = 1; dut->rd = 0; dut->wd = 12345;
    tick(dut, tfp, t);
    dut->we = 0; dut->rs1 = 0;
    tick(dut, tfp, t);
    std::cout << "rd1 (expect 0):   " << dut->rd1 << std::endl;

    tfp->close();
    delete dut;
    return 0;
}
