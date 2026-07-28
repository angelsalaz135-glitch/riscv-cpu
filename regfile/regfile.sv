module regfile (
    input  logic        clk,
    input  logic        we,           // write enable
    input  logic [4:0]  rs1, rs2,    // read addresses
    input  logic [4:0]  rd,          // write address
    input  logic [31:0] wd,          // write data
    output logic [31:0] rd1, rd2     // read data
);
    logic [31:0] regs [31:0];        // 32 registers x 32 bits

    // x0 is always zero in RISC-V
    assign rd1 = (rs1 == 5'b0) ? 32'b0 : regs[rs1];
    assign rd2 = (rs2 == 5'b0) ? 32'b0 : regs[rs2];

    always_ff @(posedge clk) begin
        if (we && rd != 5'b0)        // never write to x0
            regs[rd] <= wd;
    end
endmodule
